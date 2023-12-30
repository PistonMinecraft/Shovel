module utils

// unwrap a function used to unwrap Option that is confirmed not `none`
@[inline]
pub fn unwrap[T](t ?T) T {
	return t or { panic('unexpected `none`') }
}
