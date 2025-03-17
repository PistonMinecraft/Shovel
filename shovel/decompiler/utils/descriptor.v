module utils

pub fn field_descriptor_to_java_name(descriptor string) ?string {
	return match descriptor[0] {
		`B` { 'byte' }
		`C` { 'char' }
		`D` { 'double' }
		`F` { 'float' }
		`I` { 'int' }
		`J` { 'long' }
		`S` { 'short' }
		`Z` { 'boolean' }
		`L` { descriptor.substr(1, descriptor.len - 1) }
		else { none }
	}
}