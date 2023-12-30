module annotation

import encoding.binary
import shovel.reader.constant

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
	target_info TargetInfo
	target_path []TypePath
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

pub fn read_type_annotations(info []u8, pool constant.ConstantPool) ?[]TypeAnnotation {
	mut off := 2
	return []TypeAnnotation{len: int(binary.big_endian_u16(info)), init: read_type_annotation(info, mut
		&off, pool, index)?}
}

fn read_type_annotation(info []u8, mut offset &int, pool constant.ConstantPool, unused int) ?TypeAnnotation {
	target_type := parse_target_type(info[*offset])?
	offset += 1
	target_info := read_target_info(info, mut offset, target_type)
	target_path := read_type_path(info, mut offset)?
	t := pool.get_utf8(binary.big_endian_u16_at(info, offset))?
	offset += 2
	num_element_value_pairs := int(binary.big_endian_u16_at(info, offset))
	offset += 2
	pairs := []ElementValuePair{len: num_element_value_pairs, init: read_element_value_pair(info, mut
		offset, pool, index)?}
	return TypeAnnotation{target_type, target_info, target_path, t, pairs}
}
