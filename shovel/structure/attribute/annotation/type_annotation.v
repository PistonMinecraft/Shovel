module annotation

// ```
// type_annotation {
//   u1 target_type;
//   union {
//     type_parameter_target;
//     supertype_target;
//     type_parameter_bound_target;
//     empty_target;
//     formal_parameter_target;
//     throws_target;
//     localvar_target;
//     catch_target;
//     offset_target;
//     type_argument_target;
//   } target_info;
//   type_path target_path;
//   u2 type_index;
//   u2 num_element_value_pairs;
//   { u2 element_name_index;
//     element_value value;
//   } element_value_pairs[num_element_value_pairs];
//}
// ```
pub struct TypeAnnotation {
	target_type TargetType
	// target Use `none` to represent the empty_target
	target      ?TargetInfo
	target_path ?[]TypePath
	// type The value of the `type_index` item must be a valid index into the
	// `constant_pool` table. The `constant_pool` entry at that index must be
	// a `CONSTANT_Utf8_info` structure (§4.4.7) representing a field descriptor
	// (§4.3.2). The field descriptor denotes the type of the annotation represented
	// by this `annotation` structure.
	@type string
	// element_value_pairs Each value of the `element_value_pairs` table represents a single element-value
	// pair in the `annotation` represented by this `annotation` structure
	element_value_pairs []ElementValuePair
}
