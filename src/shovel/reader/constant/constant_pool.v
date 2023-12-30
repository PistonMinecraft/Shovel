module constant

@[heap; noinit]
pub struct ConstantPool {
pub:
	count   u16     @[required]
	entries []Entry @[required]
}

pub fn read_cp(b []u8, count u16, mut offset &int) !ConstantPool {
	mut entries := []Entry{len: int(count), init: Entry(InvalidConstantInfo{})}

	for i := u16(1); i < count; i++ {
		fat, off, info := read_cp_info(b, offset)!
		entries[i] = info
		offset += off
		if fat {
			i++
		}
	}

	return ConstantPool{count, entries}
}

pub fn (pool ConstantPool) get_loadable_info(index u16) ?Entry {
	entry := pool.entries[index]
	return if entry.is_loadable() { entry } else { none }
}

pub fn (pool ConstantPool) get_utf8(index u16) ?string {
	entry := pool.entries[index]
	return if entry is string { entry } else { none }
}

pub fn (pool ConstantPool) get_integer(index u16) ?int {
	entry := pool.entries[index]
	return if entry is int { entry } else { none }
}

pub fn (pool ConstantPool) get_long(index u16) ?i64 {
	entry := pool.entries[index]
	return if entry is i64 { entry } else { none }
}

pub fn (pool ConstantPool) get_float(index u16) ?f32 {
	entry := pool.entries[index]
	return if entry is f32 { entry } else { none }
}

pub fn (pool ConstantPool) get_double(index u16) ?f64 {
	entry := pool.entries[index]
	return if entry is f64 { entry } else { none }
}

pub fn (pool ConstantPool) get_class_info(index u16) ?ConstantClassInfo {
	entry := pool.entries[index]
	return if entry is ConstantClassInfo { entry } else { none }
}

pub fn (pool ConstantPool) get_name_and_type_info(index u16) ?ConstantNameAndTypeInfo {
	entry := pool.entries[index]
	return if entry is ConstantNameAndTypeInfo { entry } else { none }
}

pub fn (pool ConstantPool) get_method_handle_info(index u16) ?ConstantMethodHandleInfo {
	entry := pool.entries[index]
	return if entry is ConstantMethodHandleInfo { entry } else { none }
}

pub fn (pool ConstantPool) get_package_info(index u16) ?ConstantPackageInfo {
	entry := pool.entries[index]
	return if entry is ConstantPackageInfo { entry } else { none }
}

pub fn (pool ConstantPool) get_module_info(index u16) ?ConstantModuleInfo {
	entry := pool.entries[index]
	return if entry is ConstantModuleInfo { entry } else { none }
}
