module decompiler

import shovel.structure
import strings
import shovel.decompiler.utils as dutils
import shovel.utils

@[heap; noinit]
pub struct DecompilingClass {
pub:
	resolved &structure.ResolvedClass
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
			resolved:   &resolved
			package:    class.substr(0, last_package_slash).replace_char(`/`, `.`, 1)
			this_class: class.substr(last_package_slash + 1, class.len)
			// TODO: when this class is inner class
		}
	} else { // default package
		return DecompilingClass{
			resolved:   &resolved
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

	mut member_builder := strings.new_builder(64)
	for field in d.resolved.get_fields() {
		if field is structure.ResolvedField {
			acc := field.access_flags
			if acc.is_public() {
				member_builder.write_string('public ')
			} else if acc.is_protected() {
				member_builder.write_string('protected ')
			} else if acc.is_private() {
				member_builder.write_string('private ')
			}
			if acc.is_static() {
				member_builder.write_string('static ')
			} else if acc.is_transient() {
				member_builder.write_string('transient ')
			}
			if acc.is_final() {
				member_builder.write_string('final ')
			} else if acc.is_volatile() {
				member_builder.write_string('volatile ')
			}
			if acc.is_synthetic() {
				member_builder.write_string('/* synthetic */ ')
			}
			field_type := utils.unwrap(dutils.field_descriptor_to_java_name(field.descriptor))
			member_builder.write_string(field_type)
			member_builder.write_u8(` `)
			member_builder.write_string(field.name)
			member_builder.write_string(';')
			indenter.writeln_builder(mut member_builder)
		} else {
			panic('Field not resolved')
		}
	}

	for _, method_map in d.resolved.methods {
		for _, method in method_map {
			if method is structure.ResolvedMethod {
				acc := method.access_flags
				if acc.is_public() {
					member_builder.write_string('public ')
				} else if acc.is_protected() {
					member_builder.write_string('protected ')
				} else if acc.is_private() {
					member_builder.write_string('private ')
				}
				if acc.is_synchronized() {
					member_builder.write_string('synchronized ')
				}
				if acc.is_static() {
					member_builder.write_string('static ')
				} else if acc.is_abstract() {
					member_builder.write_string('abstract ')
				}
				if acc.is_final() {
					member_builder.write_string('final ')
				}
				if acc.is_native() {
					member_builder.write_string('native ')
				}
				if acc.is_synthetic() {
					member_builder.write_string('/* synthetic */ ')
				}
				if acc.is_bridge() {
					member_builder.write_string('/* bridge */ ')
				}
				if acc.is_strict() {
					member_builder.write_string('strictfp ')
				}
				ret, args := dutils.method_descriptor_to_java_name_array(method.descriptor)
				member_builder.write_string(ret)
				member_builder.write_u8(` `)
				member_builder.write_string(method.name)
				member_builder.write_u8(`(`)
				member_builder.write_string(args.join(', '))
				member_builder.write_u8(`)`)
				if acc.is_abstract() {
					member_builder.write_u8(`;`)
					indenter.writeln_builder(mut member_builder)
				} else {
					member_builder.write_string(' {')
					indenter.writeln_builder(mut member_builder)

					indenter.writeln('}')
				}
			} else {
				panic('Method not resolved')
			}
		}
	}

	indenter.pop_indent()
	builder.write_string('}\n')
	return builder
}
