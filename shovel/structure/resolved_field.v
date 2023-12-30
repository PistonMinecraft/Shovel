module structure

import shovel.reader
import shovel.reader.constant
import shovel.structure.attribute.annotation
import encoding.binary
import shovel.structure.emsg

@[heap]
pub struct ResolvedField {
	access_flags reader.FieldAccessFlag @[required]
	name         string                 @[required]
	descriptor   string                 @[required]

	raw_attributes                     ?[]reader.RawAttributeInfo
	constant_value                     ?constant.Entry
	synthetic                          bool
	deprecated                         bool
	signature                          ?string // TODO
	runtime_visible_annotations        ?[]annotation.Annotation
	runtime_invisible_annotations      ?[]annotation.Annotation
	runtime_visible_type_annotations   ?[]annotation.TypeAnnotation
	runtime_invisible_type_annotations ?[]annotation.TypeAnnotation
}

fn resolve_field(field reader.FieldInfo, pool constant.ConstantPool) !ResolvedField {
	mut raw_attributes := []reader.RawAttributeInfo{}
	mut constant_value := ?constant.Entry(none)
	mut synthetic := false
	mut deprecated := false
	mut signature := ?string(none)
	mut runtime_visible_annotations := ?[]annotation.Annotation(none)
	mut runtime_invisible_annotations := ?[]annotation.Annotation(none)
	mut runtime_visible_type_annotations := ?[]annotation.TypeAnnotation(none)
	mut runtime_invisible_type_annotations := ?[]annotation.TypeAnnotation(none)
	for attr in field.attributes {
		if attribute_name := pool.get_utf8(attr.attribute_name_index) {
			match attribute_name {
				reader.attr_constant_value {
					if constant_value == none {
						constant_value = pool.get_loadable_info(binary.big_endian_u16(attr.info))
					} else {
						return emsg.duplicated_attribute(reader.attr_constant_value)
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
	return ResolvedField{
		access_flags: field.access_flags
		name: pool.get_utf8(field.name_index) or { return emsg.invalid_name_index('field') }
		descriptor: pool.get_utf8(field.descriptor_index) or {
			return emsg.invalid_name_index('field descriptor')
		}
		raw_attributes: raw_attributes
		constant_value: constant_value
		synthetic: synthetic
		deprecated: deprecated
		signature: signature
		runtime_visible_annotations: runtime_visible_annotations
		runtime_invisible_annotations: runtime_invisible_annotations
		runtime_visible_type_annotations: runtime_visible_type_annotations
		runtime_invisible_type_annotations: runtime_invisible_type_annotations
	}
}
