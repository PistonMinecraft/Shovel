module reader

import encoding.binary

pub struct FieldInfo { // field_info
	access_flags     FieldAccessFlag    [required]
	name_index       u16                [required]
	descriptor_index u16                [required]
	attributes       []RawAttributeInfo [required]
}

pub fn read_field_info(b []u8, count u16, offset int) (int, []FieldInfo) {
	mut fields := []FieldInfo{len: int(count)}
	mut off := offset
	for i := u16(0); i < count; i++ {
		new_off, attrs := read_attribute_info(b, binary.big_endian_u16_at(b, off + 6),
			off + 8)
		fields[i] = FieldInfo{
			access_flags: FieldAccessFlag(binary.big_endian_u16_at(b, off))
			name_index: binary.big_endian_u16_at(b, off + 2)
			descriptor_index: binary.big_endian_u16_at(b, off + 4)
			attributes: attrs
		}
		off = new_off
	}
	return off, fields
}
