module reader

import encoding.binary
import shovel.reader.version
import shovel.reader.constant

pub const magic = u32(0xCAFEBABE)

pub const ( // access_flags
	acc_public = 0x0001 // class, field, method
	acc_private = 0x0002 // field, method
	acc_protected = 0x0004 // field, method

	acc_static = 0x0008 // field, method
	acc_final = 0x0010 // class, field, method
	acc_super = 0x0020 // class
	acc_synchronized = 0x0020 // method
	acc_volatile = 0x0040 // field
	acc_bridge = 0x0040 // method
	acc_transient = 0x0080 // field
	acc_varargs = 0x0080 // method
	acc_native = 0x0100 // method
	acc_interface = 0x0200 // class
	acc_abstract = 0x0400 // class, method
	acc_strict = 0x0800 // method
	acc_synthetic = 0x1000 // class, field, method

	acc_annotation = 0x2000 // class
	acc_enum = 0x4000 // class, field

	acc_module = 0x8000 // class
)

[heap]
pub struct ClassFile {
pub:
	version version.ClassVersion [required]
	constant_pool constant.ConstantPool [required]
	access_flags u16 [required]
	this_class u16 [required]
	super_class u16 [required]
	interfaces []u16 [required]
	fields []FieldInfo [required]
	methods []MethodInfo [required]
	attributes []RawAttributeInfo [required]
}

pub fn read(b []u8) !ClassFile {
	if b.len < 4 || binary.big_endian_u32(b) != reader.magic { // u4 magic
		return error('Invalid class file')
	}

	// u2 minor_version; u2 major_version
	class_version := version.ClassVersion{binary.big_endian_u16_at(b, 4),
		version.parse_major(binary.big_endian_u16_at(b, 6)) or {
			return error('Unknown major class version: ${binary.big_endian_u16_at(b, 6)}')
		}}
	if !class_version.is_valid() {
		return error('Invalid class version')
	}

	mut off := 0
	off0, cp := constant.read_cp(b, binary.big_endian_u16_at(b, 8))! // u2 constant_pool_count; cp_info constant_pool[constant_pool_count-1]
	off = off0

	access := binary.big_endian_u16_at(b, off) // u2 access_flags
	this_class := binary.big_endian_u16_at(b, off + 2) // u2 this_class
	super_class := binary.big_endian_u16_at(b, off + 4) // u2 super_class

	itf_count := binary.big_endian_u16_at(b, off + 6) // u2 interface_count
	off += 8
	itfs := []u16{len: int(itf_count), init: binary.big_endian_u16_at(b, off + it * 2)} // u2 interfaces[interfaces_count]
	off += 2 * itf_count

	fields_count := binary.big_endian_u16_at(b, off) // u2 fields_count
	off1, fields := read_field_info(b, fields_count, off + 2) // field_info fields[fields_count]

	methods_count := binary.big_endian_u16_at(b, off1) // u2 methods_count
	off2, methods := read_method_info(b, methods_count, off1 + 2) // method_info methods[methods_count]

	attrs_count := binary.big_endian_u16_at(b, off2) // u2 attributes_count
	off3, attrs := read_attribute_info(b, attrs_count, off2 + 2) // attribute_info attributes[attributes_count]

	if off3 != b.len {
		return error('Invalid class file')
	}

	return ClassFile{
		version: class_version
		constant_pool: cp
		access_flags: access
		this_class: this_class
		super_class: super_class
		interfaces: itfs
		fields: fields
		methods: methods
		attributes: attrs
	}
}
