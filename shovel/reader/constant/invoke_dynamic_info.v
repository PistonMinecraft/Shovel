module constant

import shovel.reader.version

// CONSTANT_InvokeDynamic
pub struct ConstantInvokeDynamicInfo {
pub:
	// u2 bootstrap_method_attr_index
	// points to an entry in the bootstrap method table
	bootstrap_method_attr_index u16 @[required]
	// u2 name_and_type_index
	// points to a NameAndTypeInfo(CONSTANT_NameAndType_info) whose descriptor must be a *method* descriptor
	name_and_type_index u16 @[required]
}

@[inline]
fn (c ConstantInvokeDynamicInfo) since() version.MajorVersion {
	return .v7
}

@[inline]
fn (c ConstantInvokeDynamicInfo) since_preview() bool {
	return false
}

@[inline]
fn (c ConstantInvokeDynamicInfo) tag() InfoTag {
	return .constant_invoke_dynamic
}
