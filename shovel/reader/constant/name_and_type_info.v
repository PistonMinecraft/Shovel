module constant

// CONSTANT_NameAndType_info
pub struct ConstantNameAndTypeInfo {
pub:
// u2 name_index
// points to a CONSTANT_Utf8_info, which represents a field, a method name, or the special method name "<init>"
	name_index u16 [required]
// u2 descriptor_index
// points to a CONSTANT_Utf8_info, which represents a field/method descriptor
	descriptor_index u16 [required]
}

[inline]
fn (n ConstantNameAndTypeInfo) tag() InfoTag {
	return .constant_name_and_type
}
