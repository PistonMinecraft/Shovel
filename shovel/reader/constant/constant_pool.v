module constant

[heap]
pub struct ConstantPool {
pub:
	count u16 [required]
	entries []Entry [required]
}

pub fn read_cp(b []u8, count u16) !(int, ConstantPool) {
	mut entries := []Entry{len: int(count), init: Entry(InvalidConstantInfo{})}
	mut offset := 10

	for i := u16(1); i < count; i++ {
		fat, off, info := read_cp_info(b, offset)!
		entries[i] = info
		offset += off
		if fat {
			i++
		}
	}

	return offset, ConstantPool{count, entries}
}

pub fn (pool ConstantPool) get_utf8(index u16) ?string {
	entry := pool.entries[index]
	return if entry is string { entry } else { none }
}

pub fn (pool ConstantPool) get_class_name(index u16) ?string {
	entry := pool.entries[index]
	return if entry is ConstantClassInfo { pool.get_utf8(entry.name_index) } else { none }
}

// pub fn (pool ConstantPool) get_ref(index u16) ?&ConstantRefInfo {
// 	pool.check_entry_index(index) ?
// 	entry := pool[index]
// 	if entry is ConstantRefInfo {
// 		match entry.tag {
// 			reader.constant_fieldref, reader.constant_methodref, reader.constant_interface_methodref {
// 				return entry
// 			}
// 			else {
// 				return error('Invalid tag for this entry')
// 			}
// 		}
// 	} else {
// 		return error('Constant entry is not CONSTANT_Fieldref_info, CONSTANT_Methodref_info or CONSTANT_InterfaceMethodref_info')
// 	}
// }
//
// pub fn (info &ConstantRefInfo) get_class_name(pool ConstantPool) ?string {
// 	return pool.get_class_name(info.class_index)
// }
//
// pub fn (info &ConstantRefInfo) get_name_and_type(pool ConstantPool) ?&ConstantNameAndTypeInfo {
// 	return pool.get_name_and_type(info.name_and_type_index)
// }
//
// pub fn (pool ConstantPool) get_string(index u16) ?string {
// 	pool.check_entry_index(index) ?
// 	entry := pool[index]
// 	if entry is ConstantStringInfo {
// 		pool.check_entry_tag(entry, reader.constant_string) ?
// 		return pool.get_utf8(entry.string_index)
// 	} else {
// 		return error('Constant entry is not CONSTANT_String_info')
// 	}
// }
//
// pub fn (pool ConstantPool) get_int(index u16) ?int {
// 	pool.check_entry_index(index) ?
// 	entry := pool[index]
// 	if entry is Constant4BInfo {
// 		return entry.get_int()
// 	} else {
// 		return error('Constant entry is not CONSTANT_Integer_info')
// 	}
// }
//
// pub fn (pool ConstantPool) get_f32(index u16) ?f32 {
// 	pool.check_entry_index(index) ?
// 	entry := pool[index]
// 	if entry is Constant4BInfo {
// 		return entry.get_f32()
// 	} else {
// 		return error('Constant entry is not CONSTANT_Float_info')
// 	}
// }
//
// pub fn (pool ConstantPool) get_i64(index u16) ?i64 {
// 	pool.check_entry_index(index) ?
// 	entry := pool[index]
// 	if entry is Constant8BInfo {
// 		return entry.get_i64()
// 	} else {
// 		return error('Constant entry is not CONSTANT_Long_info')
// 	}
// }
//
// pub fn (pool ConstantPool) get_f64(index u16) ?f64 {
// 	pool.check_entry_index(index) ?
// 	entry := pool[index]
// 	if entry is Constant8BInfo {
// 		return entry.get_f64()
// 	} else {
// 		return error('Constant entry is not CONSTANT_Double_info')
// 	}
// }
//
// pub fn (pool ConstantPool) get_name_and_type(index u16) ?&ConstantNameAndTypeInfo {
// 	pool.check_entry_index(index) ?
// 	entry := pool[index]
// 	if entry is ConstantNameAndTypeInfo {
// 		pool.check_entry_tag(entry, reader.constant_name_and_type) ?
// 		return entry
// 	} else {
// 		return error('Constant entry is not CONSTANT_NameAndType_info')
// 	}
// }
//
// pub fn (info &ConstantNameAndTypeInfo) get_name(pool ConstantPool) ?string {
// 	return pool.get_utf8(info.name_index)
// }
//
// pub fn (info &ConstantNameAndTypeInfo) get_descriptor(pool ConstantPool) ?string {
// 	return pool.get_utf8(info.descriptor_index)
// }

// pub fn (pool ConstantPool) get_method_handle(index u16) ?&ConstantMethodHandleInfo {
// 	pool.check_entry_index(index) ?
// 	entry := pool[index]
// 	if entry is ConstantMethodHandleInfo {
// 		pool.check_entry_tag(entry, reader.constant_method_handle) ?
// 		return entry
// 	} else {
// 		return error('Constant entry is not CONSTANT_MethodHandle_info')
// 	}
// }
//
// pub fn (info &ConstantMethodHandleInfo) get_reference(pool ConstantPool) ?&ConstantRefInfo {
// 	return pool.get_ref(info.reference_index)
// }
//
// pub fn (pool ConstantPool) get_method_type_descriptor(index u16) ?string {
// 	pool.check_entry_index(index) ?
// 	entry := pool[index]
// 	if entry is ConstantMethodTypeInfo {
// 		pool.check_entry_tag(entry, reader.constant_method_type) ?
// 		return pool.get_utf8(entry.descriptor_index)
// 	} else {
// 		return error('Constant entry is not CONSTANT_MethodType_info')
// 	}
// }
//
// pub fn (pool ConstantPool) get_dynamic(index u16) ?&ConstantDynamicInfo {
// 	pool.check_entry_index(index) ?
// 	entry := pool[index]
// 	if entry is ConstantDynamicInfo {
// 		match entry.tag {
// 			reader.constant_dynamic, reader.constant_invoke_dynamic {
// 				return entry
// 			}
// 			else {
// 				return error('Invalid tag for this entry')
// 			}
// 		}
// 		return entry
// 	} else {
// 		return error('Constant entry is not CONSTANT_Dynamic_info or CONSTANT_InvokeDynamic_info')
// 	}
// }
//
// pub fn (info &ConstantDynamicInfo) get_name_and_type(pool ConstantPool) ?&ConstantNameAndTypeInfo {
// 	return pool.get_name_and_type(info.name_and_type_index)
// }
//
// pub fn (pool ConstantPool) get_module_name(index u16) ?string {
// 	pool.check_entry_index(index) ?
// 	entry := pool[index]
// 	if entry is ConstantModuleInfo {
// 		pool.check_entry_tag(entry, reader.constant_module) ?
// 		return pool.get_utf8(entry.name_index)
// 	} else {
// 		return error('Constant entry is not CONSTANT_Module_info')
// 	}
// }
//
// pub fn (pool ConstantPool) get_package_name(index u16) ?string {
// 	pool.check_entry_index(index) ?
// 	entry := pool[index]
// 	if entry is ConstantPackageInfo {
// 		pool.check_entry_tag(entry, reader.constant_package) ?
// 		return pool.get_utf8(entry.name_index)
// 	} else {
// 		return error('Constant entry is not CONSTANT_Package_info')
// 	}
// }
