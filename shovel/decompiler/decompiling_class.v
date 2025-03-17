module decompiler

import shovel.structure
import strings
import shovel.decompiler.utils as dutils
import shovel.utils

@[heap; noinit]
pub struct DecompilingClass {
pub:
	resolved structure.ResolvedClass
	// class name of the package
	package ?string
	// class name of the class
	this_class string
}

pub fn DecompilingClass.new(mut resolved structure.ResolvedClass) DecompilingClass {
	resolved.resolve_all_members()
	class := resolved.this_class
	if last_package_slash := class.last_index('/') {
		return DecompilingClass{
			resolved:   resolved
			package:    class.substr(0, last_package_slash).replace_char(`/`, `.`, 1)
			this_class: class.substr(last_package_slash + 1, class.len)
			// TODO: when this class is inner class
		}
	} else { // default package
		return DecompilingClass{
			resolved:   resolved
			package:    none
			this_class: class
		}
	}
}

pub fn (d DecompilingClass) decompile_class(importer Importer) []u8 {
	mut builder := strings.new_builder(1024)

	{
		acc := d.resolved.access_flags
		if acc.is_public() {
			builder.write_string('public ')
		}

		if acc.is_final() {
			builder.write_string('final ')
		} else if acc.is_abstract() {
			builder.write_string('abstract ')
		}

		builder.write_string(match true {
			acc.is_interface() { 'interface ' }
			acc.is_enum() { 'enum ' }
			acc.is_annotation() { '@interface ' }
			else { 'class ' }
		})
	}

	builder.write_string(d.this_class)
	builder.writeln(' {')
	mut indenter := Indenter.new(builder)
	indenter.push_indent()

	for field in d.resolved.get_fields() {
		if field is structure.ResolvedField {
			acc := field.access_flags
			if acc.is_public() {
				indenter.write_string('public ')
			} else if acc.is_protected() {
				indenter.write_string('protected ')
			} else if acc.is_private() {
				indenter.write_string('private ')
			}
			if acc.is_static() {
				indenter.write_string('static ')
			} else if acc.is_transient() {
				indenter.write_string('transient ')
			}
			if acc.is_final() {
				indenter.write_string('final ')
			} else if acc.is_volatile() {
				indenter.write_string('volatile ')
			}
			if acc.is_synthetic() {
				indenter.write_string('/* synthetic */ ')
			}
			field_type := utils.unwrap(dutils.field_descriptor_to_java_name(field.descriptor))
			if field.descriptor[0] == `L` {
				indenter.write_string(field_type)
			}
			// indenter.write_string(field.)
		} else {
			panic('Field not resolved')
		}
	}

	indenter.pop_indent()
	builder.write_string('}')
	return builder
}
