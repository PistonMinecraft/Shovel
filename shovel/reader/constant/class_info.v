module constant

// CONSTANT_Class_info
pub struct ConstantClassInfo {
pub:
	// u2 name_index;
	// points to a CONSTANT_Utf8_info
	// holds a internal name of a class or
	// a descriptor of an array
	name_index u16 @[required]
}

@[inline]
fn (c ConstantClassInfo) tag() InfoTag {
	return .constant_class
}
