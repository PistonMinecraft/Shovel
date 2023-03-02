module reader

import encoding.binary

pub const ( // attribute names
	attr_constant_value = 'ConstantValue'
)

pub struct RawAttributeInfo {
pub:
	attribute_name_index u16
	info []u8
}

pub fn read_attribute_info(b[] u8, count u16, offset int) (int, []RawAttributeInfo) {
	mut info_arr := []RawAttributeInfo{len: int(count)}
	mut off := offset
	for i := u16(0); i < count; i++ {
		len := binary.big_endian_u32_at(b, off + 2) // int(len) potential overflow
		info_arr[i] = RawAttributeInfo{binary.big_endian_u16_at(b, off), b[off + 6..off + 6 + int(len)]}
		off += 6 + int(len)
	}
	return off, info_arr
}

// pub fn (info AttributeInfo) get_constant_value_index(pool ConstantPool) ?u16 {
// 	if pool.get_utf8(info.attribute_name_index) ? != reader.attr_constant_value {
// 		return error('This is not a $reader.attr_constant_value attribute')
// 	}
// 	if info.attribute_length != u32(2) {
// 		return error('Invalid length')
// 	}
// 	return binary.big_endian_u16(info.info)
// }
