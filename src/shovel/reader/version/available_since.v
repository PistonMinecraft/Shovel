module version

pub interface AvailableSince {
	since() MajorVersion
	since_preview() bool
}

@[inline]
pub fn (a AvailableSince) available_in(v ClassVersion) bool {
	return u16(v.major) >= u16(a.since()) && (!a.since_preview() || v.is_preview())
}
