module structure

[inline]
fn duplicated(attr_name string) IError {
	return error('Duplicated ${attr_name} attribute')
}

[inline]
fn invalid(attr_name string) IError {
	return error('Invalid ${attr_name} attribute')
}

fn conflict(a string, b string) IError {
	return error('${a} and ${b} conflicted')
}
