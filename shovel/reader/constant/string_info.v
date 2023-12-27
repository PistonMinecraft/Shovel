module constant

// CONSTANT_String_info
pub struct ConstantStringInfo {
pub:
	// u2 string_index
	// points to a CONSTANT_Utf8_info
	string_index u16 @[required]
}

@[inline]
fn (s ConstantStringInfo) tag() InfoTag {
	return .constant_string
}
