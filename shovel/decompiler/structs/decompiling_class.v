module structs

import shovel.structure

[heap; noinit]
pub struct DecompilingClass {
pub:
	resolved structure.ResolvedClass
	// class name of the package
	package ?string
	// class name of the class
	this_class string
}

pub fn new_decompiling_class(resolved structure.ResolvedClass) DecompilingClass {
	class := resolved.this_class
	if last_package_slash := class.last_index('/') {
		return DecompilingClass{
			resolved: resolved
			package: class.substr(0, last_package_slash).replace_char(`/`, `.`, 1)
			this_class: class.substr(last_package_slash + 1, class.len) // TODO: when this class is inner class
		}
	} else { // default package
		return DecompilingClass{
			resolved: resolved
			package: none
			this_class: class
		}
	}
}

pub fn (d &DecompilingClass) decompile() //&u8

{
}
