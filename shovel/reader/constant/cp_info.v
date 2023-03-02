module constant

import encoding.binary
import math

// tags of cp_info
pub enum InfoTag as u8 {
	unknown
	// CONSTANT_Utf8
	constant_utf8
	// CONSTANT_Integer
	constant_integer = 3
	// CONSTANT_Float
	constant_float
	// CONSTANT_Long
	constant_long
	// CONSTANT_Double
	constant_double
	// CONSTANT_Class
	constant_class
	// CONSTANT_String
	constant_string
	// CONSTANT_Fieldref
	constant_fieldref
	// CONSTANT_Methodref
	constant_methodref
	// CONSTANT_InterfaceMethodref
	constant_interface_methodref
	// CONSTANT_NameAndType
	constant_name_and_type
	// CONSTANT_MethodHandle(7)
	constant_method_handle = 15
	// CONSTANT_MethodType(7)
	constant_method_type
	// CONSTANT_Dynamic(11)
	constant_dynamic
	// CONSTANT_InvokeDynamic(7)
	constant_invoke_dynamic
	// CONSTANT_Module(9)
	constant_module
	// CONSTANT_Package(9)
	constant_package
}

pub interface ConstantPoolInfo { // cp_info
	tag() InfoTag // u1 tag
} // ignore u1[] info

pub struct InvalidConstantInfo { // implements ConstantPoolInfo
}

[inline]
pub fn (i InvalidConstantInfo) tag() InfoTag {
	return .unknown
}

pub type Entry = InvalidConstantInfo | int | f32 | i64 | f64 | string | ConstantClassInfo
			| ConstantModuleInfo | ConstantNameAndTypeInfo | ConstantPackageInfo
			| ConstantStringInfo | ConstantFieldrefInfo | ConstantMethodrefInfo
			| ConstantInterfaceMethodrefInfo | ConstantMethodHandleInfo | ConstantMethodTypeInfo
			| ConstantDynamicInfo | ConstantInvokeDynamicInfo

[inline]
fn parse_tag(tag u8) !InfoTag {
	if tag > 0 && tag <= 20 && tag !in [2, 13, 14] {
		return unsafe { InfoTag(tag) }
	}
	return error('Invalid constant pool tag: ${tag}')
}

fn read_cp_info(b []u8, off int) !(bool, int, Entry) {
	tag := parse_tag(b[off])!
	return match tag {
		.constant_class { false, 3, Entry(ConstantClassInfo{binary.big_endian_u16_at(b, off + 1)}) }
		.constant_fieldref { false, 5, Entry(ConstantFieldrefInfo{
				binary.big_endian_u16_at(b, off + 1), binary.big_endian_u16_at(b, off + 3)
		}) }
		.constant_methodref { false, 5, Entry(ConstantMethodrefInfo{
			binary.big_endian_u16_at(b, off + 1), binary.big_endian_u16_at(b, off + 3)
		}) }
		.constant_interface_methodref { false, 5, Entry(ConstantInterfaceMethodrefInfo{
			binary.big_endian_u16_at(b, off + 1), binary.big_endian_u16_at(b, off + 3)
		}) }
		.constant_string { false, 3, Entry(ConstantStringInfo{binary.big_endian_u16_at(b, off + 1)}) }
		.constant_integer { false, 5, Entry(int(binary.big_endian_u32_at(b, off + 1))) }
		.constant_float { false, 5, Entry(math.f32_from_bits(binary.big_endian_u32_at(b, off + 1))) }
		.constant_long { true, 9, Entry(i64(binary.big_endian_u64_at(b, off + 1))) }
		.constant_double { true, 9, Entry(math.f64_from_bits(binary.big_endian_u64_at(b, off + 1))) }
		.constant_name_and_type { false, 5, Entry(ConstantNameAndTypeInfo{
			binary.big_endian_u16_at(b, off + 1), binary.big_endian_u16_at(b, off + 3)
		}) }
		.constant_utf8 {
			length := binary.big_endian_u16_at(b, off + 1)
			false, 3 + length, Entry(parse_utf8_info(b, off + 3, length))
		}
		.constant_method_handle { false, 4, Entry(ConstantMethodHandleInfo{
			parse_reference_kind(b[off + 1])!, binary.big_endian_u16_at(b, off + 2)
		}) }
		.constant_method_type { false, 3, Entry(ConstantMethodTypeInfo{binary.big_endian_u16_at(b, off + 1)}) }
		.constant_dynamic { false, 5, Entry(ConstantDynamicInfo{
				binary.big_endian_u16_at(b, off + 1), binary.big_endian_u16_at(b, off + 3)
		}) }
		.constant_invoke_dynamic { false, 5, Entry(ConstantInvokeDynamicInfo{
			binary.big_endian_u16_at(b, off + 1), binary.big_endian_u16_at(b, off + 3)
		}) }
		.constant_module { false, 3, Entry(ConstantModuleInfo{binary.big_endian_u16_at(b, off + 1)}) }
		.constant_package { false, 3, Entry(ConstantPackageInfo{binary.big_endian_u16_at(b, off + 1)}) }
		else { error('Unknown constant pool tag') }
	}
}
