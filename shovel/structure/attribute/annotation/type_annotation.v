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
	target      TargetInfo
	target_path TypePath
}

pub struct TypePath {
}
