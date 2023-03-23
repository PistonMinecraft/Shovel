module reader

// access_flags
pub const (
	acc_public       = 0x0001 // class, field, method
	acc_private      = 0x0002 // field, method
	acc_protected    = 0x0004 // field, method

	acc_static       = 0x0008 // field, method
	acc_final        = 0x0010 // class, field, method
	acc_super        = 0x0020 // class
	acc_synchronized = 0x0020 // method
	acc_volatile     = 0x0040 // field
	acc_bridge       = 0x0040 // method
	acc_transient    = 0x0080 // field
	acc_varargs      = 0x0080 // method
	acc_native       = 0x0100 // method
	acc_interface    = 0x0200 // class
	acc_abstract     = 0x0400 // class, method
	acc_strict       = 0x0800 // method
	acc_synthetic    = 0x1000 // class, field, method, module

	acc_annotation   = 0x2000 // class
	acc_enum         = 0x4000 // class, field

	acc_module       = 0x8000 // class
	acc_open         = 0x0020 // module
	acc_mandated     = 0x8000 // module
)

pub type ClassAccessFlag = u16
pub type FieldAccessFlag = u16
pub type MethodAccessFlag = u16
pub type ModuleAccessFlag = u16
pub type CFAccessFlag = ClassAccessFlag | FieldAccessFlag
pub type FMAccessFlag = FieldAccessFlag | MethodAccessFlag
pub type CMAccessFlag = ClassAccessFlag | MethodAccessFlag
pub type AccessFlag = ClassAccessFlag | FieldAccessFlag | MethodAccessFlag

pub fn (f AccessFlag) is_public() bool {
	return (match f {
		ClassAccessFlag { f }
		FieldAccessFlag { f }
		MethodAccessFlag { f }
	} & reader.acc_public) != 0
}

pub fn (f AccessFlag) is_private() bool {
	return (match f {
		ClassAccessFlag { f }
		FieldAccessFlag { f }
		MethodAccessFlag { f }
	} & reader.acc_private) != 0
}

pub fn (f AccessFlag) is_protected() bool {
	return (match f {
		ClassAccessFlag { f }
		FieldAccessFlag { f }
		MethodAccessFlag { f }
	} & reader.acc_protected) != 0
}

pub fn (f FMAccessFlag) is_static() bool {
	return (match f {
		FieldAccessFlag { f }
		MethodAccessFlag { f }
	} & reader.acc_static) != 0
}

pub fn (f AccessFlag) is_final() bool {
	return (match f {
		ClassAccessFlag { f }
		FieldAccessFlag { f }
		MethodAccessFlag { f }
	} & reader.acc_final) != 0
}

pub fn (f ClassAccessFlag) is_super() bool {
	return (f & reader.acc_super) != 0
}

pub fn (f MethodAccessFlag) is_synchronized() bool {
	return (f & reader.acc_synchronized) != 0
}

pub fn (f FieldAccessFlag) is_volatile() bool {
	return (f & reader.acc_volatile) != 0
}

pub fn (f MethodAccessFlag) is_bridge() bool {
	return (f & reader.acc_bridge) != 0
}

pub fn (f FieldAccessFlag) is_transient() bool {
	return (f & reader.acc_transient) != 0
}

pub fn (f MethodAccessFlag) is_varargs() bool {
	return (f & reader.acc_varargs) != 0
}

pub fn (f MethodAccessFlag) is_native() bool {
	return (f & reader.acc_native) != 0
}

pub fn (f ClassAccessFlag) is_interface() bool {
	return (f & reader.acc_interface) != 0
}

pub fn (f CMAccessFlag) is_abstract() bool {
	return (match f {
		ClassAccessFlag { f }
		MethodAccessFlag { f }
	} & reader.acc_abstract) != 0
}

pub fn (f MethodAccessFlag) is_strict() bool {
	return (f & reader.acc_strict) != 0
}

pub fn (f AccessFlag) is_synthetic() bool {
	return (match f {
		ClassAccessFlag { f }
		FieldAccessFlag { f }
		MethodAccessFlag { f }
	} & reader.acc_synthetic) != 0
}

pub fn (f ClassAccessFlag) is_annotation() bool {
	return (f & reader.acc_annotation) != 0
}

pub fn (f CFAccessFlag) is_enum() bool {
	return (match f {
		ClassAccessFlag { f }
		FieldAccessFlag { f }
	} & reader.acc_enum) != 0
}

pub fn (f ClassAccessFlag) is_module() bool {
	return (f & reader.acc_module) != 0
}

pub fn (f ModuleAccessFlag) is_module_synthetic() bool {
	return (f & reader.acc_synthetic) != 0
}

pub fn (f ModuleAccessFlag) is_module_open() bool {
	return (f & reader.acc_open) != 0
}

pub fn (f ModuleAccessFlag) is_module_mandated() bool {
	return (f & reader.acc_mandated) != 0
}
