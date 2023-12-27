module modules

import shovel.reader

pub const acc_open = 0x0020 // module

pub const acc_transitive = 0x0020 // requires

pub const acc_static_phase = 0x0040 // requires

pub type ModuleAccessFlag = u16

@[inline]
pub fn (f ModuleAccessFlag) is_module_synthetic() bool {
	return (f & reader.acc_synthetic) != 0
}

@[inline]
pub fn (f ModuleAccessFlag) is_module_open() bool {
	return (f & modules.acc_open) != 0
}

@[inline]
pub fn (f ModuleAccessFlag) is_module_mandated() bool {
	return (f & reader.acc_mandated) != 0
}

pub type RequiresAccessFlag = u16

@[inline]
pub fn (f RequiresAccessFlag) is_requires_synthetic() bool {
	return (f & reader.acc_synthetic) != 0
}

@[inline]
pub fn (f RequiresAccessFlag) is_requires_transitive() bool {
	return (f & modules.acc_transitive) != 0
}

@[inline]
pub fn (f RequiresAccessFlag) is_requires_static_phase() bool {
	return (f & modules.acc_static_phase) != 0
}

@[inline]
pub fn (f RequiresAccessFlag) is_requires_mandated() bool {
	return (f & reader.acc_mandated) != 0
}

pub type ExportsOpensAccessFlag = u16

@[inline]
pub fn (f ExportsOpensAccessFlag) is_exports_or_opens_synthetic() bool {
	return (f & reader.acc_synthetic) != 0
}

@[inline]
pub fn (f ExportsOpensAccessFlag) is_exports_or_opens_mandated() bool {
	return (f & reader.acc_mandated) != 0
}
