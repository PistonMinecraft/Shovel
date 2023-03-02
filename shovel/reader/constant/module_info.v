module constant

import shovel.reader.version

// CONSTANT_Module
pub struct ConstantModuleInfo {
pub:
// u2 name_index
// points to a CONSTANT_Utf8_info, which represents a valid module name
	name_index u16 [required]
}

[inline]
fn (m ConstantModuleInfo) since() version.MajorVersion {
	return .v9
}

[inline]
fn (m ConstantModuleInfo) since_preview() bool {
	return false
}

[inline]
fn (m ConstantModuleInfo) tag() InfoTag {
	return .constant_module
}
