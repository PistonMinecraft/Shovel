module decompiler

import shovel.structure
import strings
import shovel.decompiler.structs
import shovel.utils

pub fn decompile(class_map structure.ClassMap) {
	for _, class in class_map.class_map {
		decompile_class(class, class_map)
	}
}

pub fn decompile_class(class structure.ResolvedClass, m structure.ClassMap) {
	dc := structs.new_decompiling_class(class)
	mut buf := strings.new_builder(80)

	if dc.package != none { // inside a package
		buf.writeln('package ${utils.unwrap(dc.package)};')
	}
}
