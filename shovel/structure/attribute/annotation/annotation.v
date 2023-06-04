module annotation

import encoding.binary
import shovel.reader.constant

pub struct Annotation {
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

pub fn read_annotations(info []u8, pool constant.ConstantPool) ?[]Annotation {
	mut off := 2
	return []Annotation{len: int(binary.big_endian_u16(info)), init: read_annotation(info, mut
		&off, pool, index)?}
}

fn read_annotation(info []u8, mut offset &int, pool constant.ConstantPool, unused int) ?Annotation { // index declared here so that this function wouldn't be called only one time in array `init`
	t := pool.get_utf8(binary.big_endian_u16_at(info, offset))?
	offset += 2
	num_element_value_pairs := int(binary.big_endian_u16_at(info, offset))
	offset += 2
	pairs := []ElementValuePair{len: num_element_value_pairs, init: read_element_value_pair(info, mut
		offset, pool, index)?}
	return Annotation{t, pairs}
}
