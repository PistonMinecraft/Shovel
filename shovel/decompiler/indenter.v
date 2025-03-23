module decompiler

import strings

@[noinit]
pub struct Indenter {
mut:
	builder &strings.Builder @[required]
	layers  int
}

// new create an indenter
// builder should not be destroyed during indenter life time
@[inline]
pub fn Indenter.new(builder &strings.Builder) Indenter {
	return Indenter{
		builder: unsafe { builder }
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

// writeln_builder writes all the content of `s` and a newline char, and clears `s`
pub fn (mut i Indenter) writeln_builder(mut s strings.Builder) {
	i.builder.write_string('    '.repeat(i.layers)) // TODO: customizable indentation char
	i.builder.write(s) or { panic(err) }
	i.builder.write_u8(`\n`)
	s.clear()
}

pub fn (i Indenter) write_to(mut sb strings.Builder) {
	sb.write(*i.builder) or { panic('This should not happen') }
}
