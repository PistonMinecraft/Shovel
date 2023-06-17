module emsg

pub fn illegal_java_code(msg string) IError {
	return error('Illegal Java code: ${msg}')
}
