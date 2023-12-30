module constant

import shovel.reader.version

pub enum ReferenceKind {
	get_field          = 1
	get_static
	put_field
	put_static
	invoke_virtual
	invoke_static
	invoke_special
	new_invoke_special
	invoke_interface
}

fn ReferenceKind.parse(reference_kind u8) !ReferenceKind {
	if reference_kind >= u8(ReferenceKind.get_field)
		&& reference_kind <= u8(ReferenceKind.invoke_interface) {
		return unsafe { ReferenceKind(reference_kind) }
	}
	return error('Unknown reference kind: ${reference_kind}')
}

// CONSTANT_MethodHandle
pub struct ConstantMethodHandleInfo {
pub:
	// u1 reference_kind
	reference_kind ReferenceKind @[required]
	// u2 reference_index
	// points to a RefInfo
	// when reference_kind is 1, 2, 3, or 4, then it must point to a ConstantFieldrefInfo(CONSTANT_Fieldref_info)
	// when reference_kind is 5 or 8, then it must point to a ConstantMethodrefInfo(CONSTANT_Methodref_info)
	// if reference_kind is 8, then the ConstantMethodrefInfo must represent a <init> method(constructor method)
	// when reference_kind is 6 or 7, then it must point to a ConstantMethodrefInfo(CONSTANT_Methodref_info)(class version < 52.0)
	// or, it must point to ConstantMethodrefInfo(CONSTANT_Methodref_info) or ConstantInterfaceMethodrefInfo(CONSTANT_InterfaceMethodref_info)(class version >= 52.0)
	// when reference_kind is 9, then it must point to a ConstantInterfaceMethodrefInfo(CONSTANT_InterfaceMethodref_info)
	reference_index u16 @[required]
}

@[inline]
fn (m ConstantMethodHandleInfo) since() version.MajorVersion {
	return .v7
}

@[inline]
fn (m ConstantMethodHandleInfo) since_preview() bool {
	return false
}

@[inline]
fn (m ConstantMethodHandleInfo) tag() InfoTag {
	return .constant_method_handle
}
