module decompiling

import shovel.structure
import strings

@[heap; noinit]
pub struct DecompilingClass {
pub:
	resolved structure.ResolvedClass
	// class name of the package
	package ?string
	// class name of the class
	this_class string
}

pub fn new_decompiling_class(mut resolved structure.ResolvedClass) DecompilingClass {
	resolved.resolve_all_members()
	class := resolved.this_class
	if last_package_slash := class.index_last('/') {
		return DecompilingClass{
			resolved: resolved
			package: class.substr(0, last_package_slash).replace_char(`/`, `.`, 1)
			this_class: class.substr(last_package_slash + 1, class.len)
			// TODO: when this class is inner class
		}
	} else { // default package
		return DecompilingClass{
			resolved: resolved
			package: none
			this_class: class
		}
	}
}

pub fn (d &DecompilingClass) decompile_class(importer Importer) []u8 {
	mut builder := strings.new_builder(512)

	{
		acc := d.resolved.access_flags
		if acc.is_class_public() {
			builder.write_string('public ')
		}

		if acc.is_class_final() {
			builder.write_string('final ')
		} else if acc.is_abstract() {
			builder.write_string('abstract ')
		}

		builder.write_string(match true {
			acc.is_interface() { 'interface ' }
			acc.is_class_enum() { 'enum ' }
			acc.is_annotation() { '@interface ' }
			else { 'class ' }
		})

		builder.write_string(d.this_class)
		builder.writeln(' {')
		mut indenter := Indenter.new(builder)
		indenter.push_indent()

		indenter.pop_indent()
		builder.write_string('}')
	}
	return builder
}
