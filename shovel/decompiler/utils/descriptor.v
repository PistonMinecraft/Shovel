module utils

fn descriptor_to_java_name(desc string, i int, field bool) ?string {
	return match desc[i] {
		`[` {
			mut dim := 1
			for j := i + 1; desc[j] == `[`; j++ { dim++ }
			descriptor_to_java_name(desc, i + dim, field)? + '[]'.repeat(dim)
		}
		`B` { 'byte' }
		`C` { 'char' }
		`D` { 'double' }
		`F` { 'float' }
		`I` { 'int' }
		`J` { 'long' }
		`S` { 'short' }
		`Z` { 'boolean' }
		`L` { desc.substr(1, desc.len - 1).replace_char(`/`, `.`, 1) }
		`V` { if field { none } else { 'void' } }
		else { none }
	}
}

pub fn field_descriptor_to_java_name(descriptor string) string {
	mut dimension := 0
	for i := 1; descriptor[i] == `[`; i++ {
		
	}
	return descriptor_to_java_name(descriptor, 0, true) or { panic('Invalid field descriptor') }
}

pub fn method_descriptor_to_java_name_array(descriptor string) (string, []string) {
	mut i := 1
	mut args := []string{cap: 4}
	for ; descriptor[i] != `)`; i++ {
		match descriptor[i] {
			`B` { args << 'byte' }
			`C` { args << 'char' }
			`D` { args << 'double' }
			`F` { args << 'float' }
			`I` { args << 'int' }
			`J` { args << 'long' }
			`S` { args << 'short' }
			`Z` { args << 'boolean' }
			`L` {
				end := descriptor.index_after(';', i + 1) or { panic('Invalid method descriptor: ${descriptor}') }
				args << descriptor.substr(i + 1, end).replace_char(`/`, `.`, 1)
				i = end
			}
			else { panic('Invalid method descriptor: ${descriptor}') }
		}
	}
	ret := match descriptor[i + 1] {
		`B` { 'byte' }
		`C` { 'char' }
		`D` { 'double' }
		`F` { 'float' }
		`I` { 'int' }
		`J` { 'long' }
		`S` { 'short' }
		`Z` { 'boolean' }
		`V` { 'void' }
		`L` { descriptor.substr(i + 2, descriptor.len - 1).replace_char(`/`, `.`, 1) }
		else { panic('Invalid method descriptor: ${descriptor}') }
	}
	return ret, args
}