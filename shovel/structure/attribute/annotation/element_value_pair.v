module annotation

import encoding.binary
import shovel.reader.constant

pub struct ElementValuePair {
	// name The value of the `element_name_index` item must be a valid index into
	// the `constant_pool` table. The `constant_pool` entry at that index must
	// be a `CONSTANT_Utf8_info` structure (§4.4.7). The `constant_pool`
	// entry denotes the name of the element of the element-value pair
	// represented by this `element_value_pairs` entry.
	//
	// _In other words, the entry denotes an element of the annotation interface specified
	// by type_index._
	name string
	// value The value of the `value` item represents the value of the element-value
	// pair represented by this `element_value_pairs` entry
	value ElementValue
}

pub type ElementValue = Annotation
	| ClassInfo
	| ConstantValue
	| EnumConstant
	| []ElementValue
	| f32
	| f64
	| i64
	| string

pub struct ConstantValue {
	@type PrimitiveType
	value int
}

// The enum_const_value item denotes an enum constant as the value of this
// element-value pair.
pub struct EnumConstant {
	// type_name The value of the `type_name_index` item must be a valid index into the
	// `constant_pool` table. The `constant_pool` entry at that index must be
	// a `CONSTANT_Utf8_info` structure (§4.4.7) representing a field descriptor
	// (§4.3.2). The `constant_pool` entry gives the internal form of the binary
	// name of the type of the enum constant represented by this `element_value`
	// structure (§4.2.1).
	type_name string
	// const_name The value of the `const_name_index` item must be a valid index into the
	// `constant_pool` table. The `constant_pool` entry at that index must be a
	// `CONSTANT_Utf8_info` structure (§4.4.7). The `constant_pool` entry gives
	// the simple name of the enum constant represented by this `element_value`
	// structure.
	const_name string
}

// The `class_info_index` item must be a valid index into the `constant_pool`
// table. The `constant_pool` entry at that index must be a `CONSTANT_Utf8_info`
// structure (§4.4.7) representing a return descriptor (§4.3.3). The return
// descriptor gives the type corresponding to the class literal represented by this
// `element_value` structure. Types correspond to class literals as follows:
//
// - For a class literal `C.class`, where `C` is the name of a class, interface,
// or array type, the corresponding type is `C`. The return descriptor in the
//`constant_pool` will be an _ObjectType_ or an _ArrayType_.
// - For a class literal `p.class`, where `p` is the name of a primitive type, the
// corresponding type is `p`. The return descriptor in the `constant_pool` will be
// a _BaseType_ character.
// - For a class literal `void.class`, the corresponding type is `void`. The return
// descriptor in the `constant_pool` will be _V_.
//
// _For example, the class literal `Object.class` corresponds to the type `Object`, so the
//`constant_pool` entry is `Ljava/lang/Object;`, whereas the class literal `int.class`
// corresponds to the type `int`, so the constant_pool entry is `I`._
//
// _The class literal `void.class` corresponds to `void`, so the `constant_pool` entry
// is `V`, whereas the class literal `Void.class` corresponds to the type `Void`, so the
//`constant_pool` entry is `Ljava/lang/Void;`._
pub struct ClassInfo {
	class_info string
}

pub const tag_byte = u8(`B`)
pub const tag_char = u8(`C`)
pub const tag_double = u8(`D`)
pub const tag_float = u8(`F`)
pub const tag_int = u8(`I`)
pub const tag_long = u8(`J`)
pub const tag_short = u8(`S`)
pub const tag_boolean = u8(`Z`)
pub const tag_string = u8(`s`)
pub const tag_enum = u8(`e`)
pub const tag_class = u8(`c`)
pub const tag_annotation = u8(`@`)
pub const tag_array = u8(`[`)

fn read_element_value_pair(info []u8, mut offset &int, pool constant.ConstantPool, unused int) ?ElementValuePair { // index declared here so that this function wouldn't be called only one time in array `init`
	name := pool.get_utf8(binary.big_endian_u16_at(info, offset))?
	offset += 2
	return ElementValuePair{name, read_element_value(info, mut offset, pool, 0)?}
}

pub fn read_element_value(info []u8, mut offset &int, pool constant.ConstantPool, unused int) ?ElementValue {
	tag := info[*offset]
	offset += 1
	return match tag {
		annotation.tag_byte {
			value := pool.get_integer(binary.big_endian_u16_at(info, offset))?
			offset += 2
			ElementValue(ConstantValue{PrimitiveType.byte, value})
		}
		annotation.tag_short {
			value := pool.get_integer(binary.big_endian_u16_at(info, offset))?
			offset += 2
			ElementValue(ConstantValue{PrimitiveType.short, value})
		}
		annotation.tag_boolean {
			value := pool.get_integer(binary.big_endian_u16_at(info, offset))?
			offset += 2
			ElementValue(ConstantValue{PrimitiveType.boolean, value})
		}
		annotation.tag_int {
			value := pool.get_integer(binary.big_endian_u16_at(info, offset))?
			offset += 2
			ElementValue(ConstantValue{PrimitiveType.int, value})
		}
		annotation.tag_char {
			value := pool.get_integer(binary.big_endian_u16_at(info, offset))?
			offset += 2
			ElementValue(ConstantValue{PrimitiveType.char, value})
		}
		annotation.tag_double {
			value := pool.get_double(binary.big_endian_u16_at(info, offset))?
			offset += 2
			ElementValue(value)
		}
		annotation.tag_float {
			value := pool.get_float(binary.big_endian_u16_at(info, offset))?
			offset += 2
			ElementValue(value)
		}
		annotation.tag_long {
			value := pool.get_long(binary.big_endian_u16_at(info, offset))?
			offset += 2
			ElementValue(value)
		}
		annotation.tag_string {
			value := pool.get_utf8(binary.big_endian_u16_at(info, offset))?
			offset += 2
			ElementValue(value)
		}
		annotation.tag_enum {
			type_name := pool.get_utf8(binary.big_endian_u16_at(info, offset))?
			offset += 2
			const_name := pool.get_utf8(binary.big_endian_u16_at(info, offset))?
			offset += 2
			ElementValue(EnumConstant{type_name, const_name})
		}
		annotation.tag_class {
			value := pool.get_utf8(binary.big_endian_u16_at(info, offset))?
			offset += 2
			ElementValue(ClassInfo{value})
		}
		annotation.tag_annotation {
			ElementValue(read_annotation(info, mut offset, pool, 0)?)
		}
		annotation.tag_array {
			len := int(binary.big_endian_u16_at(info, offset))
			offset += 2
			ElementValue([]ElementValue{len: len, init: read_element_value(info, mut offset,
				pool, index)?})
		}
		else {
			return none
		}
	}
}
