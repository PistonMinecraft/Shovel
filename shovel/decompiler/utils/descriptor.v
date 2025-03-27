module utils

fn descriptor_to_java_name(desc string, i int, allow_void bool, end bool) ?(string, int) {
	return match desc[i] {
		`[` {
			mut j := i + 1
			for desc[j] == `[` {
				j++
			}
			comp, new_index := descriptor_to_java_name(desc, j, allow_void, end)?
			comp + '[]'.repeat(j - i), new_index // j - i == dim
		}
		`B` {
			'byte', i
		}
		`C` {
			'char', i
		}
		`D` {
			'double', i
		}
		`F` {
			'float', i
		}
		`I` {
			'int', i
		}
		`J` {
			'long', i
		}
		`S` {
			'short', i
		}
		`Z` {
			'boolean', i
		}
		`L` {
			end_index := if end { desc.len - 1 } else { desc.index_after(';', i + 2)? }
			desc.substr(i + 1, end_index).replace_char(`/`, `.`, 1), end_index
		}
		`V` {
			if allow_void {
				'void', i
			} else {
				none
			}
		}
		else {
			none
		}
	}
}

pub fn field_descriptor_to_java_name(descriptor string) string {
	ret, _ := descriptor_to_java_name(descriptor, 0, false, true) or {
		panic('Invalid field descriptor: ${descriptor}')
	}
	return ret
}

pub fn method_descriptor_to_java_name_array(descriptor string) (string, []string) {
	mut i := 1
	mut args := []string{cap: 4}
	for ; descriptor[i] != `)`; i++ {
		arg, new_index := descriptor_to_java_name(descriptor, i, false, false) or {
			panic('Invalid method descriptor: ${descriptor}')
		}
		args << arg
		i = new_index
	}
	ret, _ := descriptor_to_java_name(descriptor, i + 1, true, true) or {
		panic('Invalid method descriptor: ${descriptor}')
	}
	return ret, args
}
