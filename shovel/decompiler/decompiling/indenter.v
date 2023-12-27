module decompiling

import strings

@[noinit]
pub struct Indenter {
mut:
	builder strings.Builder @[required]
	layers  int
}

@[inline]
pub fn Indenter.new(builder strings.Builder) Indenter {
	return Indenter{
		builder: builder
	}
}

pub fn (mut i Indenter) push_indent() {
	i.layers++
}

pub fn (mut i Indenter) pop_indent() {
	i.layers--
}

pub fn (mut i Indenter) writeln(s string) {
	i.builder.write_string('    '.repeat(i.layers)) // TODO: customizable indentation char
	i.builder.writeln(s)
}
