module reader

// access_flags
pub const acc_public = 0x0001 // class, field, method

pub const acc_private = 0x0002 // field, method

pub const acc_protected = 0x0004 // field, method

pub const acc_static = 0x0008 // field, method

pub const acc_final = 0x0010 // class, field, method, method_parameter

pub const acc_super = 0x0020 // class

pub const acc_synchronized = 0x0020 // method

pub const acc_volatile = 0x0040 // field

pub const acc_bridge = 0x0040 // method

pub const acc_transient = 0x0080 // field

pub const acc_varargs = 0x0080 // method

pub const acc_native = 0x0100 // method

pub const acc_interface = 0x0200 // class

pub const acc_abstract = 0x0400 // class, method

pub const acc_strict = 0x0800 // method

pub const acc_synthetic = 0x1000 // class, field, method, module, module_requires, module_exports, module_opens, method_parameter

pub const acc_annotation = 0x2000 // class

pub const acc_enum = 0x4000 // class, field

pub const acc_module = 0x8000 // class

pub const acc_mandated = 0x8000 // module, module_requires, module_exports, module_opens, method_parameter

pub type ClassAccessFlag = u16
pub type FieldAccessFlag = u16
pub type MethodAccessFlag = u16

@[inline]
pub fn (f ClassAccessFlag) is_public() bool {
	return (f & acc_public) != 0
}

@[inline]
pub fn (f FieldAccessFlag) is_public() bool {
	return (f & acc_public) != 0
}

@[inline]
pub fn (f MethodAccessFlag) is_public() bool {
	return (f & acc_public) != 0
}

@[inline]
pub fn (f ClassAccessFlag) is_private() bool {
	return (f & acc_private) != 0
}

@[inline]
pub fn (f FieldAccessFlag) is_private() bool {
	return (f & acc_private) != 0
}

@[inline]
pub fn (f MethodAccessFlag) is_private() bool {
	return (f & acc_private) != 0
}

@[inline]
pub fn (f ClassAccessFlag) is_protected() bool {
	return (f & acc_protected) != 0
}

@[inline]
pub fn (f FieldAccessFlag) is_protected() bool {
	return (f & acc_protected) != 0
}

@[inline]
pub fn (f MethodAccessFlag) is_protected() bool {
	return (f & acc_protected) != 0
}

@[inline]
pub fn (f FieldAccessFlag) is_static() bool {
	return (f & acc_static) != 0
}

@[inline]
pub fn (f MethodAccessFlag) is_static() bool {
	return (f & acc_static) != 0
}

@[inline]
pub fn (f ClassAccessFlag) is_final() bool {
	return (f & acc_final) != 0
}

@[inline]
pub fn (f FieldAccessFlag) is_final() bool {
	return (f & acc_final) != 0
}

@[inline]
pub fn (f MethodAccessFlag) is_final() bool {
	return (f & acc_final) != 0
}

@[inline]
pub fn (f ClassAccessFlag) is_super() bool {
	return (f & acc_super) != 0
}

@[inline]
pub fn (f MethodAccessFlag) is_synchronized() bool {
	return (f & acc_synchronized) != 0
}

@[inline]
pub fn (f FieldAccessFlag) is_volatile() bool {
	return (f & acc_volatile) != 0
}

@[inline]
pub fn (f MethodAccessFlag) is_bridge() bool {
	return (f & acc_bridge) != 0
}

@[inline]
pub fn (f FieldAccessFlag) is_transient() bool {
	return (f & acc_transient) != 0
}

@[inline]
pub fn (f MethodAccessFlag) is_varargs() bool {
	return (f & acc_varargs) != 0
}

@[inline]
pub fn (f MethodAccessFlag) is_native() bool {
	return (f & acc_native) != 0
}

@[inline]
pub fn (f ClassAccessFlag) is_interface() bool {
	return (f & acc_interface) != 0
}

@[inline]
pub fn (f ClassAccessFlag) is_abstract() bool {
	return (f & acc_abstract) != 0
}

@[inline]
pub fn (f MethodAccessFlag) is_abstract() bool {
	return (f & acc_abstract) != 0
}

@[inline]
pub fn (f MethodAccessFlag) is_strict() bool {
	return (f & acc_strict) != 0
}

@[inline]
pub fn (f ClassAccessFlag) is_synthetic() bool {
	return (f & acc_synthetic) != 0
}

@[inline]
pub fn (f FieldAccessFlag) is_synthetic() bool {
	return (f & acc_synthetic) != 0
}

@[inline]
pub fn (f MethodAccessFlag) is_synthetic() bool {
	return (f & acc_synthetic) != 0
}

@[inline]
pub fn (f ClassAccessFlag) is_annotation() bool {
	return (f & acc_annotation) != 0
}

@[inline]
pub fn (f ClassAccessFlag) is_enum() bool {
	return (f & acc_enum) != 0
}

@[inline]
pub fn (f FieldAccessFlag) is_enum() bool {
	return (f & acc_enum) != 0
}

@[inline]
pub fn (f ClassAccessFlag) is_module() bool {
	return (f & acc_module) != 0
}
