module structure

import shovel.reader
import shovel.structure.attribute.code as c
import shovel.reader.constant
import shovel.structure.attribute.annotation
import encoding.binary
import shovel.structure.attribute
import shovel.structure.emsg

pub struct ResolvedMethod { // method_info
	access_flags reader.MethodAccessFlag [required]
	name         string                  [required]
	descriptor   string                  [required]

	raw_attributes                          ?[]reader.RawAttributeInfo
	code                                    ?c.Code
	exceptions                              ?[]constant.ConstantClassInfo
	runtime_visible_parameter_annotations   ?[][]annotation.Annotation
	runtime_invisible_parameter_annotations ?[][]annotation.Annotation
	annotation_default                      ?annotation.ElementValue
	method_parameters                       ?[]attribute.MethodParameter
	synthetic                               bool
	deprecated                              bool
	signature                               ?string // TODO
	runtime_visible_annotations             ?[]annotation.Annotation
	runtime_invisible_annotations           ?[]annotation.Annotation
	runtime_visible_type_annotations        ?[]annotation.TypeAnnotation
	runtime_invisible_type_annotations      ?[]annotation.TypeAnnotation
}

fn resolve_method(method reader.MethodInfo, pool constant.ConstantPool) !ResolvedMethod {
	mut raw_attributes := []reader.RawAttributeInfo{}
	mut code := ?c.Code(none)
	mut exceptions := ?[]constant.ConstantClassInfo(none)
	mut runtime_visible_parameter_annotations := ?[][]annotation.Annotation{}
	mut runtime_invisible_parameter_annotations := ?[][]annotation.Annotation{}
	mut annotation_default := ?annotation.ElementValue(none)
	mut method_parameters := ?[]attribute.MethodParameter(none)
	mut synthetic := false
	mut deprecated := false
	mut signature := ?string(none)
	mut runtime_visible_annotations := ?[]annotation.Annotation(none)
	mut runtime_invisible_annotations := ?[]annotation.Annotation(none)
	mut runtime_visible_type_annotations := ?[]annotation.TypeAnnotation(none)
	mut runtime_invisible_type_annotations := ?[]annotation.TypeAnnotation(none)
	for attr in method.attributes {
		if attribute_name := pool.get_utf8(attr.attribute_name_index) {
			match attribute_name {
				reader.attr_code {
					if code == none {
						code = c.read_code(attr.info, pool) or {
							return emsg.invalid_attribute(reader.attr_code)
						}
					} else {
						return emsg.duplicated_attribute(reader.attr_code)
					}
				}
				reader.attr_exceptions {
					if exceptions == none {
						exceptions = []constant.ConstantClassInfo{len: int(binary.big_endian_u16(attr.info)), init: pool.get_class_info(binary.big_endian_u16_at(attr.info,
							2 + index * 2)) or {
							return emsg.invalid_attribute(reader.attr_exceptions)
						}}
					} else {
						return emsg.duplicated_attribute(reader.attr_exceptions)
					}
				}
				reader.attr_runtime_visible_parameter_annotations {
					if runtime_visible_parameter_annotations == none {
						mut off := 1
						runtime_visible_parameter_annotations = [][]annotation.Annotation{len: int(attr.info[0]), init: annotation.read_annotations_at(attr.info,
							pool, mut &off, index) or {
							return emsg.invalid_attribute(reader.attr_runtime_visible_parameter_annotations)
						}}
					} else {
						return emsg.duplicated_attribute(reader.attr_runtime_visible_parameter_annotations)
					}
				}
				reader.attr_runtime_invisible_parameter_annotations {
					if runtime_invisible_parameter_annotations == none {
						mut off := 1
						runtime_invisible_parameter_annotations = [][]annotation.Annotation{len: int(attr.info[0]), init: annotation.read_annotations_at(attr.info,
							pool, mut &off, index) or {
							return emsg.invalid_attribute(reader.attr_runtime_invisible_parameter_annotations)
						}}
					} else {
						return emsg.duplicated_attribute(reader.attr_runtime_invisible_parameter_annotations)
					}
				}
				reader.attr_annotation_default {
					if annotation_default == none {
						mut off := 0
						annotation_default = annotation.read_element_value(attr.info, mut
							&off, pool, 0)
					} else {
						return emsg.duplicated_attribute(reader.attr_annotation_default)
					}
				}
				reader.attr_method_parameters {
					if method_parameters == none {
						method_parameters = []attribute.MethodParameter{len: int(attr.info[0]), init: attribute.MethodParameter{
							name: pool.get_utf8(binary.big_endian_u16_at(attr.info, 1 + index * 4))
							access: attribute.MethodParameterAccess(binary.big_endian_u16_at(attr.info,
								3 + index * 4))
						}}
					} else {
						return emsg.duplicated_attribute(reader.attr_method_parameters)
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
	return ResolvedMethod{
		access_flags: method.access_flags
		name: pool.get_utf8(method.name_index) or { return emsg.invalid_name_index('method') }
		descriptor: pool.get_utf8(method.descriptor_index) or {
			return emsg.invalid_name_index('method descriptor')
		}
		raw_attributes: raw_attributes
		code: code
		exceptions: exceptions
		runtime_visible_parameter_annotations: runtime_visible_parameter_annotations
		runtime_invisible_parameter_annotations: runtime_invisible_parameter_annotations
		annotation_default: annotation_default
		method_parameters: method_parameters
		synthetic: synthetic
		deprecated: deprecated
		signature: signature
		runtime_visible_annotations: runtime_visible_annotations
		runtime_invisible_annotations: runtime_invisible_annotations
		runtime_visible_type_annotations: runtime_visible_type_annotations
		runtime_invisible_type_annotations: runtime_invisible_type_annotations
	}
}
