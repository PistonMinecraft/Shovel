module reader

import encoding.binary

pub struct FieldInfo {
pub: // field_info
	access_flags     FieldAccessFlag    @[required]
	name_index       u16                @[required]
	descriptor_index u16                @[required]
	attributes       []RawAttributeInfo @[required]
}

pub fn read_field_info(b []u8, count u16, mut offset &int) []FieldInfo {
	mut fields := []FieldInfo{len: int(count)}
	for i := u16(0); i < count; i++ {
		off := *offset
		offset += 8
		attrs := read_attribute_info(b, binary.big_endian_u16_at(b, off + 6), mut offset)
		fields[i] = FieldInfo{
			access_flags: FieldAccessFlag(binary.big_endian_u16_at(b, off))
			name_index: binary.big_endian_u16_at(b, off + 2)
			descriptor_index: binary.big_endian_u16_at(b, off + 4)
			attributes: attrs
		}
	}
	return fields
}
