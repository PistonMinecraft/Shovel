module attribute

import shovel.reader
import shovel.reader.constant
import encoding.binary
import shovel.structure.attribute.annotation
import shovel.structure.emsg

pub struct RecordComponentInfo {
	name       string [required]
	descriptor string [required]

	attributes                         []reader.RawAttributeInfo
	signature                          ?string
	runtime_visible_annotations        ?[]annotation.Annotation
	runtime_invisible_annotations      ?[]annotation.Annotation
	runtime_visible_type_annotations   ?[]annotation.TypeAnnotation
	runtime_invisible_type_annotations ?[]annotation.TypeAnnotation
}

pub fn read_record(info []u8, pool constant.ConstantPool) ![]RecordComponentInfo {
	mut offset := 2
	return []RecordComponentInfo{len: int(binary.big_endian_u16(info)), init: read_record_component_info(info, mut
		&offset, pool, index)!}
}

fn read_record_component_info(info []u8, mut offset &int, pool constant.ConstantPool, unused int) !RecordComponentInfo {
	name := pool.get_utf8(binary.big_endian_u16_at(info, offset)) or {
		return error('record component name is absent')
	}
	offset += 2
	descriptor := pool.get_utf8(binary.big_endian_u16_at(info, offset)) or {
		return error('record component descriptor is absent')
	}
	offset += 2
	attributes_count := binary.big_endian_u16_at(info, offset)
	offset += 2
	attributes := reader.read_attribute_info(info, attributes_count, mut offset)
	mut raw_attributes := []reader.RawAttributeInfo{cap: int(attributes_count)}
	mut signature := ?string(none)
	mut runtime_visible_annotations := ?[]annotation.Annotation(none)
	mut runtime_invisible_annotations := ?[]annotation.Annotation(none)
	mut runtime_visible_type_annotations := ?[]annotation.TypeAnnotation(none)
	mut runtime_invisible_type_annotations := ?[]annotation.TypeAnnotation(none)
	for attr in attributes {
		if attr_name := pool.get_utf8(attr.attribute_name_index) {
			match attr_name {
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
	return RecordComponentInfo{name, descriptor, raw_attributes, signature, runtime_visible_annotations, runtime_invisible_annotations, runtime_visible_type_annotations, runtime_invisible_type_annotations}
}
