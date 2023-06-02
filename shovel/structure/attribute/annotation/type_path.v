module annotation

pub enum TypePathKind as u8 {
	// array Annotation is deeper in an array type
	array
	// nested Annotation is deeper in a nested type
	nested
	// wildcard_type_argument Annotation is on the bound of a wildcard type argument of a parameterized type
	wildcard_type_argument
	// type_argument Annotation is on a type argument of a parameterized type
	type_argument
}

// ```
// type_path {
//   u1 path_length;
//   { u1 type_path_kind;
//     u1 type_argument_index;
//   } path[path_length];
//}
// ```
pub struct TypePath {
	type_path_kind TypePathKind
	// type_argument_index If the value of the `type_path_kind` item is `0`, `1`, or `2`, then the value of the
	// `type_argument_index` item is `0`.
	//
	// If the value of the `type_path_kind` item is `3`(type_argument), then the value of
	// the `type_argument_index` item specifies which type argument of a
	// parameterized type is annotated, where `0` indicates the first type argument
	// of a parameterized type.
	type_argument_index u8
}
