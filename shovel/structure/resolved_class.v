module structure

import shovel.reader.constant
import shovel.reader.version
import shovel.reader
import encoding.binary
import shovel.structure.attribute
import shovel.structure.attribute.annotation
import shovel.structure.attribute.modules
import shovel.structure.emsg

type Field = ResolvedField | reader.FieldInfo
type Method = ResolvedMethod | reader.MethodInfo

@[heap]
pub struct ResolvedClass {
pub:
	version       version.ClassVersion   @[required]
	constant_pool constant.ConstantPool  @[required]
	access_flags  reader.ClassAccessFlag @[required]
	this_class    string                 @[required]
	super_class   string                 @[required]
	interfaces    ?[]string

	raw_attributes                     ?[]reader.RawAttributeInfo
	source_file                        ?string
	source_debug_extension             ?string
	inner_classes                      ?[]attribute.InnerClass
	enclosing_method                   ?attribute.EnclosingMethod
	bootstrap_methods                  ?[]attribute.BootstrapMethod
	mod                                ?modules.Module
	module_packages                    ?[]constant.ConstantPackageInfo
	module_main_class                  ?constant.ConstantClassInfo
	nest_host                          ?constant.ConstantClassInfo
	nest_members                       ?[]constant.ConstantClassInfo
	record                             ?[]attribute.RecordComponentInfo
	permitted_subclasses               ?[]constant.ConstantClassInfo
	synthetic                          bool
	deprecated                         bool
	signature                          ?string // TODO
	runtime_visible_annotations        ?[]annotation.Annotation
	runtime_invisible_annotations      ?[]annotation.Annotation
	runtime_visible_type_annotations   ?[]annotation.TypeAnnotation
	runtime_invisible_type_annotations ?[]annotation.TypeAnnotation
mut:
	fields  map[string]Field             @[required]
	methods map[string]map[string]Method @[required]
}

pub fn resolve_class(class reader.ClassFile) !ResolvedClass {
	mut raw_attributes := []reader.RawAttributeInfo{}
	mut source_file := ?string(none)
	mut source_debug_extension := ?string(none)
	mut inner_classes := ?[]attribute.InnerClass(none)
	mut enclosing_method := ?attribute.EnclosingMethod(none)
	mut bootstrap_methods := ?[]attribute.BootstrapMethod(none)
	mut mod := ?modules.Module(none)
	mut module_packages := ?[]constant.ConstantPackageInfo(none)
	mut module_main_class := ?constant.ConstantClassInfo(none)
	mut nest_host := ?constant.ConstantClassInfo(none)
	mut nest_members := ?[]constant.ConstantClassInfo(none)
	mut record := ?[]attribute.RecordComponentInfo(none)
	mut permitted_subclasses := ?[]constant.ConstantClassInfo(none)
	mut synthetic := false
	mut deprecated := false
	mut signature := ?string(none)
	mut runtime_visible_annotations := ?[]annotation.Annotation(none)
	mut runtime_invisible_annotations := ?[]annotation.Annotation(none)
	mut runtime_visible_type_annotations := ?[]annotation.TypeAnnotation(none)
	mut runtime_invisible_type_annotations := ?[]annotation.TypeAnnotation(none)
	pool := class.constant_pool
	for attr in class.attributes {
		if attribute_name := pool.get_utf8(attr.attribute_name_index) {
			match attribute_name {
				reader.attr_source_file {
					if source_file == none {
						if attr.info.len != 2 {
							return emsg.invalid_attribute(reader.attr_source_file)
						}
						// The string referenced by the `sourcefile_index` item will be interpreted as indicating the
						// name of the source file from which this `class` file was compiled. It will not be interpreted
						// as indicating the name of a directory containing the file or an absolute path name for the file;
						// such platform-specific additional information must be supplied by the run-time interpreter
						// or development tool at the time the file name is actually used.
						source_file = pool.get_utf8(binary.big_endian_u16(attr.info))
					} else {
						return emsg.duplicated_attribute(reader.attr_source_file)
					}
				}
				reader.attr_inner_classes {
					if inner_classes == none {
						inner_classes = attribute.read_inner_classes(attr.info, pool) or {
							return emsg.invalid_attribute(reader.attr_inner_classes)
						}
					} else {
						return emsg.duplicated_attribute(reader.attr_inner_classes)
					}
				}
				reader.attr_enclosing_method {
					if enclosing_method == none {
						enclosing_method = attribute.read_enclosing_method(attr.info,
							pool) or { return emsg.invalid_attribute(reader.attr_enclosing_method) }
					} else {
						return emsg.duplicated_attribute(reader.attr_enclosing_method)
					}
				}
				reader.attr_source_debug_extension {
					if source_debug_extension == none {
						// The `debug_extension` array holds extended debugging information which has
						// no semantic effect on the Java Virtual Machine. The information is represented
						// using a modified UTF-8 string (§4.4.7) with no terminating zero byte.
						// > Note that the `debug_extension` array may denote a string longer than that which can be
						// > represented with an instance of class `String`.
						source_debug_extension = constant.parse_utf8_info(attr.info, 0,
							attr.info.len)
					} else {
						return emsg.duplicated_attribute(reader.attr_source_debug_extension)
					}
				}
				reader.attr_bootstrap_methods {
					if bootstrap_methods == none {
						bootstrap_methods = attribute.read_bootstrap_methods(attr.info,
							pool) or {
							return emsg.invalid_attribute(reader.attr_bootstrap_methods)
						}
					} else {
						return emsg.duplicated_attribute(reader.attr_bootstrap_methods)
					}
				}
				reader.attr_module {
					if mod == none {
						mod = modules.read_module(attr.info, pool) or {
							return emsg.invalid_attribute(reader.attr_module)
						}
					} else {
						return emsg.duplicated_attribute(reader.attr_module)
					}
				}
				reader.attr_module_packages {
					if module_packages == none {
						package_count := int(binary.big_endian_u16(attr.info))
						module_packages = []constant.ConstantPackageInfo{len: package_count, init: pool.get_package_info(binary.big_endian_u16_at(attr.info,
							2 + 2 * index)) or {
							return emsg.invalid_attribute(reader.attr_module_packages)
						}}
					} else {
						return emsg.duplicated_attribute(reader.attr_module_packages)
					}
				}
				reader.attr_module_main_class {
					if module_main_class == none {
						module_main_class = pool.get_class_info(binary.big_endian_u16(attr.info))
					} else {
						return emsg.duplicated_attribute(reader.attr_module_main_class)
					}
				}
				reader.attr_nest_host {
					if nest_host == none {
						if nest_members != none {
							return emsg.conflict(reader.attr_nest_host, reader.attr_nest_members)
						}
						nest_host = pool.get_class_info(binary.big_endian_u16(attr.info))
					} else {
						return emsg.duplicated_attribute(reader.attr_nest_host)
					}
				}
				reader.attr_nest_members {
					if nest_members == none {
						if nest_host != none {
							return emsg.conflict(reader.attr_nest_host, reader.attr_nest_members)
						}
						nest_members = []constant.ConstantClassInfo{len: int(binary.big_endian_u16(attr.info)), init: pool.get_class_info(binary.big_endian_u16_at(attr.info,
							2 + 2 * index)) or {
							return emsg.invalid_attribute(reader.attr_nest_members)
						}}
					} else {
						return emsg.duplicated_attribute(reader.attr_nest_members)
					}
				}
				reader.attr_record {
					if record == none {
						record = attribute.read_record(attr.info, pool)!
					} else {
						return emsg.duplicated_attribute(reader.attr_record)
					}
				}
				reader.attr_permitted_subclasses {
					if permitted_subclasses == none {
						permitted_subclasses = []constant.ConstantClassInfo{len: int(binary.big_endian_u16(attr.info)), init: pool.get_class_info(binary.big_endian_u16_at(attr.info,
							2 + 2 * index)) or {
							return emsg.invalid_attribute(reader.attr_permitted_subclasses)
						}}
					} else {
						return emsg.duplicated_attribute(reader.attr_permitted_subclasses)
					}
				}
				reader.attr_synthetic {
					synthetic = true
				}
				reader.attr_deprecated {
					deprecated = true
				}
				reader.attr_signature {
					if signature == none {
						signature = pool.get_utf8(binary.big_endian_u16(attr.info))
					} else {
						return emsg.duplicated_attribute(reader.attr_signature)
					}
				}
				reader.attr_runtime_visible_annotations {
					if runtime_visible_annotations == none {
						runtime_visible_annotations = annotation.read_annotations(attr.info,
							pool)
					} else {
						return emsg.duplicated_attribute(reader.attr_runtime_visible_annotations)
					}
				}
				reader.attr_runtime_invisible_annotations {
					if runtime_invisible_annotations == none {
						runtime_invisible_annotations = annotation.read_annotations(attr.info,
							pool)
					} else {
						return emsg.duplicated_attribute(reader.attr_runtime_invisible_annotations)
					}
				}
				reader.attr_runtime_visible_type_annotations {
					if runtime_visible_type_annotations == none {
						runtime_visible_type_annotations = annotation.read_type_annotations(attr.info,
							pool)
					} else {
						return emsg.duplicated_attribute(reader.attr_runtime_visible_type_annotations)
					}
				}
				reader.attr_runtime_invisible_type_annotations {
					if runtime_invisible_type_annotations == none {
						runtime_invisible_type_annotations = annotation.read_type_annotations(attr.info,
							pool)
					} else {
						return emsg.duplicated_attribute(reader.attr_runtime_invisible_type_annotations)
					}
				}
				else {
					raw_attributes << attr
				}
			}
		} else {
			raw_attributes << attr
		}
	}
	mut fields := map[string]Field{}
	for field in class.fields {
		fields[pool.get_utf8(field.name_index) or { return emsg.invalid_name_index('field') }] = Field(field)
	}
	mut methods := map[string]map[string]Method{}
	for method in class.methods {
		methods[pool.get_utf8(method.name_index) or { return emsg.invalid_name_index('method') }][pool.get_utf8(method.descriptor_index) or {
			return emsg.invalid_name_index('descriptor')
		}] = Method(method)
	}
	return ResolvedClass{
		version: class.version
		constant_pool: pool
		access_flags: class.access_flags
		this_class: pool.get_utf8(class.this_class) or { return emsg.invalid_name_index('class') }
		super_class: pool.get_utf8(class.super_class) or { return emsg.invalid_name_index('class') }
		interfaces: class.interfaces.map(pool.get_utf8(it) or {
			return emsg.invalid_name_index('interface')
		})
		raw_attributes: raw_attributes
		source_file: source_file
		source_debug_extension: source_debug_extension
		inner_classes: inner_classes
		enclosing_method: enclosing_method
		bootstrap_methods: bootstrap_methods
		mod: mod
		module_packages: module_packages
		module_main_class: module_main_class
		nest_host: nest_host
		nest_members: nest_members
		record: record
		permitted_subclasses: permitted_subclasses
		synthetic: synthetic
		deprecated: deprecated
		signature: signature
		runtime_visible_annotations: runtime_visible_annotations
		runtime_invisible_annotations: runtime_invisible_annotations
		runtime_visible_type_annotations: runtime_visible_type_annotations
		runtime_invisible_type_annotations: runtime_invisible_type_annotations
		fields: fields
		methods: methods
	}
}

pub fn (mut r ResolvedClass) resolve_all_members() {
	for k, v in r.fields {
		if v is reader.FieldInfo {
			r.fields[k] = resolve_field(v, r.constant_pool) or { panic('Unable to resolve field') } // TODO: better error handling
		}
	}
	for n, dm in r.methods {
		for d, v in dm {
			if v is reader.MethodInfo {
				r.methods[n][d] = resolve_method(v, r.constant_pool) or {
					panic('Unable to resolve method')
				} // TODO: better error handling
			}
		}
	}
}
