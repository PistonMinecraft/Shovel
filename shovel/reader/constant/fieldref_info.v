module constant

// CONSTANT_Fieldref_info
pub struct ConstantFieldrefInfo {
pub:
// u2 class_index
// points to a ConstantClassInfo(CONSTANT_Class_info), which holds a *class or interface* type
	class_index u16 [required]
// u2 name_and_type_index
// points to a NameAndTypeInfo(CONSTANT_NameAndType_info), which holds a *field* descriptor
	name_and_type_index u16 [required]
}

[inline]
fn (c ConstantFieldrefInfo) tag() InfoTag {
	return .constant_fieldref
}
