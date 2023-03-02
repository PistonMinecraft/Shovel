module version

pub const preview_minor = u16(65535)

pub struct ClassVersion {
pub:
// u2 minor_version
	minor u16
// u2 major_version
	major MajorVersion [required]
}

[inline]
pub fn (v ClassVersion) is_preview() bool {
	return u16(v.major) >= u16(MajorVersion.v12) && v.minor == u16(preview_minor)
}

pub fn (v ClassVersion) is_valid() bool {
	if u16(v.major) >= u16(MajorVersion.v12) {
		return v.minor == u16(preview_minor) || v.minor == u16(0)
	}
	return true
}
