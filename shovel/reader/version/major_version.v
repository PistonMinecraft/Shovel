module version

pub const latest_major = MajorVersion.v20

pub enum MajorVersion as u16 {
	v1_1 = 45
	v1_2
	v1_3
	v1_4
	v5
	v6
	v7
	v8
	v9
	v10
	v11
	v12
	v13
	v14
	v15
	v16
	v17
	v18
	v19
	v20
}

@[inline]
pub fn parse_major(major_version u16) ?MajorVersion {
	if major_version >= u16(MajorVersion.v1_1) && major_version <= u16(version.latest_major) {
		return unsafe { MajorVersion(major_version) }
	}
	return none
}
