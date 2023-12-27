module attribute

import shovel.reader.constant
import encoding.binary

// The `EnclosingMethod` attribute is a fixed-length attribute in the `attributes` table
// of a `ClassFile` structure (§4.1). A class must have an `EnclosingMethod` attribute
// **if and only if** it represents a local class or an anonymous class (JLS §14.3, JLS §15.9.5).
// There may be **at most one** `EnclosingMethod` attribute in the `attributes` table of a `ClassFile` structure.
// ```
// EnclosingMethod_attribute {
//  u2 attribute_name_index;
//  u4 attribute_length;
//  u2 class_index;
//  u2 method_index;
// }
// ```
pub struct EnclosingMethod {
	// **Innermost** class that encloses the declaration of the current class.
	//
	// The value of the `class_index` item must be a valid index into the
	// `constant_pool` table. The `constant_pool` entry at that index must be a
	// `CONSTANT_Class_info` structure (§4.4.1) representing the **innermost** class that
	// encloses the declaration of the current class.
	class constant.ConstantClassInfo @[required]
	// If the current class is not immediately enclosed by a method or constructor,
	// then the value of the `method_index` item **must** be zero.
	//
	// > In particular, `method_index` must be zero if the current class was immediately enclosed
	// > in source code by an instance initializer, static initializer, instance variable initializer, or
	// > class variable initializer. (The first two concern both local classes and anonymous classes,
	// > while the last two concern anonymous classes declared on the right hand side of a field assignment.)
	// Otherwise, the value of the `method_index` item must be a valid index into
	// the `constant_pool` table. The `constant_pool` entry at that index must be a
	// `CONSTANT_NameAndType_info` structure (§4.4.6) representing the name and
	// type of a method in the class referenced by the `class_index` attribute above.
	method ?constant.ConstantNameAndTypeInfo
}

pub fn read_enclosing_method(info []u8, pool constant.ConstantPool) ?EnclosingMethod {
	return EnclosingMethod{
		class: pool.get_class_info(binary.big_endian_u16(info))?
		method: pool.get_name_and_type_info(binary.big_endian_u16_at(info, 2))
	}
}
