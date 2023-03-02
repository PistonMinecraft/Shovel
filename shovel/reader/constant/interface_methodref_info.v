module constant

// CONSTANT_InterfaceMethodref_info
pub struct ConstantInterfaceMethodrefInfo {
pub:
// u2 class_index
// points to a ConstantClassInfo(CONSTANT_Class_info), which holds a *interface* type
	class_index u16 [required]
// u2 name_and_type_index
// points to a NameAndTypeInfo(CONSTANT_NameAndType_info), which holds a *method* descriptor
	name_and_type_index u16 [required]
}

[inline]
fn (c ConstantInterfaceMethodrefInfo) tag() InfoTag {
	return .constant_interface_methodref
}
