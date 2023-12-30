module decompiler

import shovel.structure
import strings
import shovel.decompiler.decompiling
import shovel.utils

pub fn decompile(mut class_map structure.ClassMap) {
	for _, mut class in class_map.class_map {
		decompile_class(mut class, class_map)
	}
}

pub fn decompile_class(mut class structure.ResolvedClass, m structure.ClassMap) {
	dc := decompiling.new_decompiling_class(mut class)
	mut buf := strings.new_builder(80)

	if dc.package != none { // inside a package
		buf.writeln('package ${utils.unwrap(dc.package)};')
		buf.write_u8(`\n`)
	}

	importer := decompiling.Importer{}
	result := dc.decompile_class(importer)
	importer.collect_imports(mut buf)
	buf.write(result) or { panic('should not happen') }
	println(buf.str())
}
