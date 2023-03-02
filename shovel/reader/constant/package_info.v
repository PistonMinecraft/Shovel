module constant

import shovel.reader.version

// CONSTANT_Package
pub struct ConstantPackageInfo {
pub:
// u2 name_index
// points to a CONSTANT_Utf8_info, which represents a valid package name in internal form
	name_index u16 [required]
}

[inline]
fn (m ConstantPackageInfo) since() version.MajorVersion {
	return .v9
}

[inline]
fn (m ConstantPackageInfo) since_preview() bool {
	return false
}

[inline]
fn (m ConstantPackageInfo) tag() InfoTag {
	return .constant_module
}
