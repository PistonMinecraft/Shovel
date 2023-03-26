module structure

import shovel.reader.constant
import shovel.reader.version
import shovel.reader
import encoding.binary
import shovel.structure.attribute
import datatypes

type Field = ResolvedField | reader.FieldInfo
type Method = ResolvedMethod | reader.MethodInfo

[heap]
pub struct ResolvedClass {
pub:
	version                version.ClassVersion       [required]
	constant_pool          constant.ConstantPool      [required]
	access_flags           reader.ClassAccessFlag     [required]
	this_class             string                     [required]
	super_class            string                     [required]
	interfaces             ?datatypes.Set[string]
	raw_attributes         ?[]reader.RawAttributeInfo
	source_file            ?string
	source_debug_extension ?string
	inner_classes          ?[]attribute.InnerClass
	enclosing_method       ?attribute.EnclosingMethod
mut:
	fields  map[string]Field             [required]
	methods map[string]map[string]Method [required]
}

pub fn resolve_class(class reader.ClassFile) !ResolvedClass {
	mut raw_attributes := []reader.RawAttributeInfo{}
	mut source_file := ?string(none)
	mut source_debug_extension := ?string(none)
	mut inner_classes := ?[]attribute.InnerClass(none)
	mut enclosing_method := ?attribute.EnclosingMethod(none)
	mut bootstrap_methods := ?[]attribute.BootstrapMethod(none)
	pool := class.constant_pool
	for attr in class.attributes {
		if attribute_name := pool.get_utf8(attr.attribute_name_index) {
			match attribute_name {
				reader.attr_source_file {
					if source_file == none {
						if attr.info.len != 2 {
							return invalid(reader.attr_source_file)
						}
						// The string referenced by the `sourcefile_index` item will be interpreted as indicating the
						// name of the source file from which this `class` file was compiled. It will not be interpreted
						// as indicating the name of a directory containing the file or an absolute path name for the file;
						// such platform-specific additional information must be supplied by the run-time interpreter
						// or development tool at the time the file name is actually used.
						source_file = pool.get_utf8(binary.big_endian_u16(attr.info))
					} else {
						return duplicated(reader.attr_source_file)
					}
				}
				reader.attr_inner_classes {
					if inner_classes == none {
						inner_classes = attribute.read_inner_classes(attr.info, pool) or {
							return invalid(reader.attr_inner_classes)
						}
					} else {
						return duplicated(reader.attr_inner_classes)
					}
				}
				reader.attr_enclosing_method {
					if enclosing_method == none {
						enclosing_method = attribute.read_enclosing_method(attr.info,
							pool) or { return invalid(reader.attr_enclosing_method) }
					} else {
						return duplicated(reader.attr_enclosing_method)
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
						return duplicated(reader.attr_source_debug_extension)
					}
				}
				reader.attr_bootstrap_methods {
					if bootstrap_methods == none {
						bootstrap_methods = attribute.read_bootstrap_methods(attr.info,
							pool) or { return invalid(reader.attr_bootstrap_methods) }
					} else {
						return duplicated(reader.attr_bootstrap_methods)
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
	return error('TODO')
}
