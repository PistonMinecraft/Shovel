module modules

import shovel.reader

// The Module attribute is a variable-length attribute in the attributes table of a
// ClassFile structure (§4.1). The Module attribute indicates the modules required
// by a module; the packages exported and opened by a module; and the services used
// and provided by a module.
// There may be at most one Module attribute in the attributes table of a ClassFile
// structure.
//
// Module_attribute {
//   u2 attribute_name_index;
//   u4 attribute_length;
//
//   u2 module_name_index;
//   u2 module_flags;
//   u2 module_version_index;
//
//   u2 requires_count;
//   { u2 requires_index;
//     u2 requires_flags;
//     u2 requires_version_index;
//   } requires[requires_count];
//
//   u2 exports_count;
//   { u2 exports_index;
//     u2 exports_flags;
//     u2 exports_to_count;
//     u2 exports_to_index[exports_to_count];
//   } exports[exports_count];
//
//   u2 opens_count;
//   { u2 opens_index;
//     u2 opens_flags;
//     u2 opens_to_count;
//     u2 opens_to_index[opens_to_count];
//   } opens[opens_count];
//
//   u2 uses_count;
//   u2 uses_index[uses_count];
//
//   u2 provides_count;
//   { u2 provides_index;
//     u2 provides_with_count;
//     u2 provides_with_index[provides_with_count];
//   } provides[provides_count];
// }
pub struct Module {
	// The value of the `module_name_index` item must be a valid index into the
	// `constant_pool` table. The `constant_pool` entry at that index must be a
	// `CONSTANT_Module_info` structure (§4.4.11) denoting the current module.
	name     string
	flags    reader.ModuleAccessFlag
	version  ?string
	requires struct {
	}

	exports struct {
	}

	opens struct {
	}

	uses     []u16
	provides struct {
	}
}
