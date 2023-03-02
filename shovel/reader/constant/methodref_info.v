module constant

// CONSTANT_Methodref_info
pub struct ConstantMethodrefInfo {
pub:
// u2 class_index
// points to a ConstantClassInfo(CONSTANT_Class_info), which holds a *class* type
	class_index u16 [required]
// u2 name_and_type_index
// points to a NameAndTypeInfo(CONSTANT_NameAndType_info), which holds a *method* descriptor
// if the name begins with a '<'(\u003c), then the name must be "<init>", and the return type must be void
	name_and_type_index u16 [required]
}

[inline]
fn (c ConstantMethodrefInfo) tag() InfoTag {
	return .constant_methodref
}
