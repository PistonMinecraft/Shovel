module constant

import shovel.reader.version

// CONSTANT_Dynamic
pub struct ConstantDynamicInfo {
pub:
// u2 bootstrap_method_attr_index
// points to an entry in the bootstrap method table
	bootstrap_method_attr_index u16 [required]
// u2 name_and_type_index
// points to a NameAndTypeInfo(CONSTANT_NameAndType_info) whose descriptor must be a *field* descriptor
	name_and_type_index u16 [required]
}

[inline]
fn (c ConstantDynamicInfo) since() version.MajorVersion {
	return .v11
}

[inline]
fn (c ConstantDynamicInfo) since_preview() bool {
	return false
}

[inline]
fn (c ConstantDynamicInfo) tag() InfoTag {
	return .constant_dynamic
}
