module structure

import shovel.reader

type Class = ResolvedClass | reader.ClassFile

[heap]
pub struct ClassMap {
mut:
	class_map         map[string]Class
	library_class_map map[string]Class
}

pub fn create_class_map(source []reader.ClassFile, libraries [][]reader.ClassFile) ?ClassMap {
	mut class_map := map[string]Class{}
	mut library_class_map := map[string]Class{}
	for class in source {
		class_map[class.constant_pool.get_utf8(class.this_class)?] = class
	}
	for lib in libraries {
		for class in lib {
			library_class_map[class.constant_pool.get_utf8(class.this_class)?] = class
		}
	}
	return ClassMap{class_map, library_class_map}
}
