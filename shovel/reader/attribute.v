module reader

import encoding.binary

// attribute names
pub const (
	attr_source_file            = 'SourceFile'
	attr_source_debug_extension = 'SourceDebugExtension'
	attr_inner_classes          = 'InnerClasses'
	attr_enclosing_method       = 'EnclosingMethod'
	attr_bootstrap_methods      = 'BootstrapMethods'
	attr_constant_value         = 'ConstantValue'
)

pub struct RawAttributeInfo {
pub:
	attribute_name_index u16  [required]
	info                 []u8 [required]
}

pub fn read_attribute_info(b []u8, count u16, offset int) (int, []RawAttributeInfo) {
	mut info_arr := []RawAttributeInfo{len: int(count)}
	mut off := offset
	for i := u16(0); i < count; i++ {
		len := int(binary.big_endian_u32_at(b, off + 2))
		if len < 0 { // potential overflow
			panic('number overflow')
		}
		info_arr[i] = RawAttributeInfo{binary.big_endian_u16_at(b, off), b[off + 6..off + 6 + len]}
		off += 6 + len
	}
	return off, info_arr
}
