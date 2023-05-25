module attribute

import shovel.reader
import shovel.reader.constant
import encoding.binary

pub struct RecordComponentInfo {
	name       string
	descriptor string

	attributes                         []reader.RawAttributeInfo
	signature                          string
	runtime_visible_annotations        []u16
	runtime_invisible_annotations      []u16
	runtime_visible_type_annotations   []u16
	runtime_invisible_type_annotations []u16
}

pub fn read_record(info []u8, pool constant.ConstantPool) ?[]RecordComponentInfo {
	mut ret := []RecordComponentInfo{len: int(binary.big_endian_u16(info))}
	for i := 2; i < info.len; i += 2 {
	}
	return none
}

fn read_record_component_info(info []u8, offset int, pool constant.ConstantPool) ?RecordComponentInfo {
	mut raw_attributes := []reader.RawAttributeInfo{}
	for i := offset + 4; i < info.len; i += 2 {
	}
	return none
}
