module constant

import shovel.reader.version

// CONSTANT_Class_info
// u2 name_index;
// points to a CONSTANT_Utf8_info
// holds a internal name of a class or
// a descriptor of an array
pub type ConstantClassInfo = u16

@[inline]
pub fn (c ConstantClassInfo) tag() InfoTag { // implements ConstantPoolInfo
	return .constant_class
}

// CONSTANT_String_info
// u2 string_index
// points to a CONSTANT_Utf8_info
pub type ConstantStringInfo = u16

@[inline]
fn (s ConstantStringInfo) tag() InfoTag {
	return .constant_string
}

// CONSTANT_Package
// u2 name_index
// points to a CONSTANT_Utf8_info, which represents a valid package name in internal form
pub type ConstantPackageInfo = u16

@[inline]
fn (m ConstantPackageInfo) since() version.MajorVersion {
	return .v9
}

@[inline]
fn (m ConstantPackageInfo) since_preview() bool {
	return false
}

@[inline]
fn (m ConstantPackageInfo) tag() InfoTag {
	return .constant_module
}

// CONSTANT_Module
// u2 name_index
// points to a CONSTANT_Utf8_info, which represents a valid module name
pub type ConstantModuleInfo = u16

@[inline]
fn (m ConstantModuleInfo) since() version.MajorVersion {
	return .v9
}

@[inline]
fn (m ConstantModuleInfo) since_preview() bool {
	return false
}

@[inline]
fn (m ConstantModuleInfo) tag() InfoTag {
	return .constant_module
}

// CONSTANT_MethodType
// u2 descriptor_index
// points to a CONSTANT_Utf8_info, which represents a method descriptor
pub type ConstantMethodTypeInfo = u16

@[inline]
fn (m ConstantMethodTypeInfo) since() version.MajorVersion {
	return .v7
}

@[inline]
fn (m ConstantMethodTypeInfo) since_preview() bool {
	return false
}

@[inline]
fn (m ConstantMethodTypeInfo) tag() InfoTag {
	return .constant_method_type
}
