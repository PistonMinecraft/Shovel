module utils

[inline]
pub fn duplicated_attribute(attr_name string) IError {
	return error('Duplicated ${attr_name} attribute')
}

[inline]
pub fn invalid_attribute(attr_name string) IError {
	return error('Invalid ${attr_name} attribute')
}

[inline]
pub fn invalid_name_index(name string) IError {
	return error('Invalid ${name} name index')
}

pub fn conflict(a string, b string) IError {
	return error('${a} and ${b} conflicted')
}
