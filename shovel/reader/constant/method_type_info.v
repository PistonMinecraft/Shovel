module constant

import shovel.reader.version

// CONSTANT_MethodType
pub struct ConstantMethodTypeInfo {
pub:
// u2 descriptor_index
// points to a CONSTANT_Utf8_info, which represents a method descriptor
	descriptor_index u16 [required]
}

[inline]
fn (m ConstantMethodTypeInfo) since() version.MajorVersion {
	return .v7
}

[inline]
fn (m ConstantMethodTypeInfo) since_preview() bool {
	return false
}

[inline]
fn (m ConstantMethodTypeInfo) tag() InfoTag {
	return .constant_method_type
}
