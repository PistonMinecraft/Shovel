module code

import shovel.reader
import shovel.structure.attribute.annotation

// The `Code` attribute is a variable-length attribute in the `attributes` table of
// a `method_info` structure (§4.6). A `Code` attribute contains the Java Virtual
// Machine instructions and auxiliary information for a method, including an instance
// initialization method and a class or interface initialization method (§2.9.1, §2.9.2).
//
// If the method is either `native` or `abstract`, and is not a class or interface
// initialization method, then its `method_info` structure must not have a Code attribute
// in its `attributes` table. Otherwise, its `method_info` structure must have exactly
// one `Code` attribute in its attributes table.
//
// The `Code` attribute has the following format:
// ```
// Code_attribute {
//   u2 attribute_name_index;
//   u4 attribute_length;
//   u2 max_stack;
//   u2 max_locals;
//   u4 code_length;
//   u1 code[code_length];
//   u2 exception_table_length;
//   { u2 start_pc;
//     u2 end_pc;
//     u2 handler_pc;
//     u2 catch_type;
//   } exception_table[exception_table_length];
//   u2 attributes_count;
//   attribute_info attributes[attributes_count];
// }
// ```
pub struct Code {
	// max_stack The value of the `max_stack` item gives the maximum depth of the operand
	// stack of this method (§2.6.2) at any point during execution of the method.
	max_stack u16
	// max_locals The value of the `max_locals` item gives the number of local variables in
	// the local variable array allocated upon invocation of this method (§2.6.1),
	// including the local variables used to pass parameters to the method on its
	// invocation.
	//
	// The greatest local variable index for a value of type `long` or `double` is
	// `max_locals - 2`. The greatest local variable index for a value of any other
	// type is `max_locals - 1`.
	max_locals u16
	// The value of the `code_length` item gives the number of bytes in the code array
	// for this method.
	// The value of `code_length` must be greater than zero (as the `code` array must
	// not be empty) and less than 65536.
	//
	// The `code` array gives the actual bytes of Java Virtual Machine code that
	// implement the method.
	//
	// When the `code` array is read into memory on a byte-addressable machine, if
	// the first byte of the array is aligned on a 4-byte boundary, the _tableswitch_ and
	// _lookupswitch_ 32-bit offsets will be 4-byte aligned. (Refer to the descriptions
	// of those instructions for more information on the consequences of `code` array alignment.)
	// The detailed constraints on the contents of the `code` array are extensive and are
	// given in a separate section (§4.9).
	code            []u8
	exception_table []ExceptionTableEntry

	raw_attributes                     ?[]reader.RawAttributeInfo
	runtime_visible_type_annotations   ?[]annotation.TypeAnnotation
	runtime_invisible_type_annotations ?[]annotation.TypeAnnotation
}
