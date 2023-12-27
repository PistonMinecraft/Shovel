module decompiling

import shovel.decompiler.emsg
import strings

@[heap]
pub struct Importer {
mut:
	imported map[string]string
}

// add_import adds an import
// `class` internal name of the importing class
// returns the symbol should be used in code
pub fn (mut i Importer) add_import(dc DecompilingClass, importing string) !string {
	name := if last_slash := importing.index_last('/') {
		importing.substr(last_slash + 1, importing.len)
	} else {
		return if dc.package != none {
			emsg.illegal_java_code('Class "${dc.resolved.this_class}" not in the default package is trying to access class "${importing}" in the default package')
		} else {
			importing
		} // No need to import the default package
	}
	importing_class_name := importing.replace_char(`/`, `.`, 1)
	return if s := i.imported[name] {
		if s == importing_class_name { // already imported
			name
		} else { // class name duplicated, use fqcn
			importing_class_name
		}
	} else { // not imported
		i.imported[name] = importing_class_name
		name
	}
}

// collect_imports collect all the imports
pub fn (i &Importer) collect_imports(mut builder strings.Builder) {
	mut values := i.imported.values()
	values.sort()
	for v in values {
		builder.writeln('import ${v};')
	}
	builder.write_u8(`\n`)
}
