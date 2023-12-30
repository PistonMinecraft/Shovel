module attribute

import shovel.reader

pub type MethodParameterAccess = u16

@[inline]
pub fn (f MethodParameterAccess) is_method_parameter_final() bool {
	return (f & reader.acc_final) != 0
}

@[inline]
pub fn (f MethodParameterAccess) is_method_parameter_synthetic() bool {
	return (f & reader.acc_synthetic) != 0
}

@[inline]
pub fn (f MethodParameterAccess) is_method_parameter_mandated() bool {
	return (f & reader.acc_mandated) != 0
}

pub struct MethodParameter {
	name   ?string
	access MethodParameterAccess
}
