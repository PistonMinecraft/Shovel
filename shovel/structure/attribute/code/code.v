module code

import shovel.reader
import shovel.structure.attribute.annotation
import shovel.reader.constant
import encoding.binary
import shovel.structure.utils

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
[heap]
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
	line_number_table                  ?[]LineNumber
	local_variable_table               ?[]LocalVariable
	local_variable_type_table          ?[]LocalVariableType
	stack_map_table                    ?[]StackMapFrame
	runtime_visible_type_annotations   ?[]annotation.TypeAnnotation
	runtime_invisible_type_annotations ?[]annotation.TypeAnnotation
}

pub fn read_code(info []u8, pool constant.ConstantPool) !Code {
	max_stack := binary.big_endian_u16(info)
	max_locals := binary.big_endian_u16_at(info, 2)
	mut off := 8 + int(binary.big_endian_u32_at(info, 4))
	code := info[8..off]
	exception_table_length := int(binary.big_endian_u16_at(info, off))
	off += 2
	exception_table := []ExceptionTableEntry{len: exception_table_length, init: ExceptionTableEntry{
		start_pc: binary.big_endian_u16_at(info, off + index * 8)
		end_pc: binary.big_endian_u16_at(info, off + index * 8 + 2)
		handler_pc: binary.big_endian_u16_at(info, off + index * 8 + 4)
		catch_type: pool.get_class_info(binary.big_endian_u16_at(info, off + index * 8 + 6))
	}}
	off += exception_table_length * 8
	attributes_count := binary.big_endian_u16_at(info, off)
	off += 2
	attributes := reader.read_attribute_info(info, attributes_count, mut &off)
	mut raw_attributes := []reader.RawAttributeInfo{cap: int(attributes_count)}
	mut line_number_table := ?[]LineNumber(none)
	mut local_variable_table := ?[]LocalVariable(none)
	mut local_variable_type_table := ?[]LocalVariableType(none)
	mut stack_map_table := ?[]StackMapFrame(none)
	mut runtime_visible_type_annotations := ?[]annotation.TypeAnnotation(none)
	mut runtime_invisible_type_annotations := ?[]annotation.TypeAnnotation(none)
	for attr in attributes {
		if attr_name := pool.get_utf8(attr.attribute_name_index) {
			match attr_name {
				reader.attr_line_number_table {
					if line_number_table == none {
						line_number_table = []LineNumber{len: int(binary.big_endian_u16(attr.info)), init: LineNumber{
							start_pc: binary.big_endian_u16_at(attr.info, 2 + index * 4)
							line_number: binary.big_endian_u16_at(attr.info, 4 + index * 4)
						}}
					} else {
						line_number_table << []LineNumber{len: int(binary.big_endian_u16(attr.info)), init: LineNumber{
							start_pc: binary.big_endian_u16_at(attr.info, 2 + index * 4)
							line_number: binary.big_endian_u16_at(attr.info, 4 + index * 4)
						}}
					}
				}
				reader.attr_local_variable_table {
					if local_variable_table == none {
						local_variable_table = []LocalVariable{len: int(binary.big_endian_u16(attr.info)), init: LocalVariable{
							start_pc: binary.big_endian_u16_at(attr.info, 2 + index * 10)
							length: binary.big_endian_u16_at(attr.info, 4 + index * 10)
							name: pool.get_utf8(binary.big_endian_u16_at(attr.info, 6 + index * 10)) or {
								return error('local variable name is absent')
							}
							descriptor: pool.get_utf8(binary.big_endian_u16_at(attr.info,
								8 + index * 10)) or {
								return error('local variable descriptor is absent')
							}
							index: binary.big_endian_u16_at(attr.info, 10 + index * 10)
						}}
					} else {
						local_variable_table << []LocalVariable{len: int(binary.big_endian_u16(attr.info)), init: LocalVariable{
							start_pc: binary.big_endian_u16_at(attr.info, 2 + index * 10)
							length: binary.big_endian_u16_at(attr.info, 4 + index * 10)
							name: pool.get_utf8(binary.big_endian_u16_at(attr.info, 6 + index * 10)) or {
								return error('local variable name is absent')
							}
							descriptor: pool.get_utf8(binary.big_endian_u16_at(attr.info,
								8 + index * 10)) or {
								return error('local variable descriptor is absent')
							}
							index: binary.big_endian_u16_at(attr.info, 10 + index * 10)
						}}
					}
				}
				reader.attr_local_variable_type_table {
					if local_variable_type_table == none {
						local_variable_type_table = []LocalVariableType{len: int(binary.big_endian_u16(attr.info)), init: LocalVariableType{
							start_pc: binary.big_endian_u16_at(attr.info, 2 + index * 10)
							length: binary.big_endian_u16_at(attr.info, 4 + index * 10)
							name: pool.get_utf8(binary.big_endian_u16_at(attr.info, 6 + index * 10)) or {
								return error('local variable type name is absent')
							}
							signature: pool.get_utf8(binary.big_endian_u16_at(attr.info,
								8 + index * 10)) or {
								return error('local variable type signature is absent')
							}
							index: binary.big_endian_u16_at(attr.info, 10 + index * 10)
						}}
					} else {
						local_variable_type_table << []LocalVariableType{len: int(binary.big_endian_u16(attr.info)), init: LocalVariableType{
							start_pc: binary.big_endian_u16_at(attr.info, 2 + index * 10)
							length: binary.big_endian_u16_at(attr.info, 4 + index * 10)
							name: pool.get_utf8(binary.big_endian_u16_at(attr.info, 6 + index * 10)) or {
								return error('local variable type name is absent')
							}
							signature: pool.get_utf8(binary.big_endian_u16_at(attr.info,
								8 + index * 10)) or {
								return error('local variable type signature is absent')
							}
							index: binary.big_endian_u16_at(attr.info, 10 + index * 10)
						}}
					}
				}
				reader.attr_stack_map_table {
					if stack_map_table == none {
						stack_map_table = read_stack_map_table(attr.info, pool)
					} else {
						return utils.duplicated_attribute(reader.attr_stack_map_table)
					}
				}
				reader.attr_runtime_visible_type_annotations {
					if runtime_visible_type_annotations == none {
						runtime_visible_type_annotations = annotation.read_type_annotations(attr.info,
							pool)
					} else {
						return utils.duplicated_attribute(reader.attr_runtime_visible_type_annotations)
					}
				}
				reader.attr_runtime_invisible_type_annotations {
					if runtime_invisible_type_annotations == none {
						runtime_invisible_type_annotations = annotation.read_type_annotations(attr.info,
							pool)
					} else {
						return utils.duplicated_attribute(reader.attr_runtime_invisible_type_annotations)
					}
				}
				else {
					raw_attributes << attr
				}
			}
		} else {
			raw_attributes << attr
		}
	}
	return Code{
		max_stack: max_stack
		max_locals: max_locals
		code: code
		exception_table: exception_table
		raw_attributes: raw_attributes
		line_number_table: line_number_table
		local_variable_table: local_variable_table
		local_variable_type_table: local_variable_type_table
		stack_map_table: stack_map_table
		runtime_visible_type_annotations: runtime_visible_type_annotations
		runtime_invisible_type_annotations: runtime_invisible_type_annotations
	}
}
