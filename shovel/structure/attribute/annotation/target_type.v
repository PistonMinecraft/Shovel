module annotation

pub enum TargetType as u8 {
	// class_type_parameter type parameter declaration of generic class or interface
	// Appears in: ClassFile
	class_type_parameter
	// method_type_parameter type parameter declaration of generic method or constructor
	// Appears in: method_info
	method_type_parameter
	// supertype type in extends or implements clause of class declaration (including the direct superclass or
	// direct superinterface of an anonymous class declaration), or in extends clause of interface declaration
	// Appears in: ClassFile
	supertype                   = 0x10
	// class_type_parameter_bound type in bound of type parameter declaration of generic class or interface
	// Appears in: ClassFile
	class_type_parameter_bound
	// method_type_parameter_bound type in bound of type parameter declaration of generic method or constructor
	// Appears in: method_info
	method_type_parameter_bound
	// field_empty_target type in field or record component declaration
	// Appears in: field_info, record_component_info
	field_empty_target
	// return_empty_target return type of method, or type of newly constructed object
	// Appears in: method_info
	return_empty_target
	// receiver_empty_target receiver type of method or constructor
	// Appears in: method_info
	receiver_empty_target
	// formal_parameter type in formal parameter declaration of method, constructor, or lambda expression
	// Appears in: method_info
	formal_parameter
	// throws type in `throws` clause of method or constructor
	// Appears in: method_info
	throws
	// All below appear in: Code
	// localvar type in local variable declaration
	localvar                    = 0x40
	// resource_localvar type in resource variable declaration
	resource_localvar
	// catch type in exception parameter declaration
	catch
	// instanceof_offset type in instanceof expression
	instanceof_offset
	// new_offset type in new expression
	new_offset
	// refnew_offset type in method reference expression using `::new`
	refnew_offset
	// refmethod_offset type in method reference expression using `::Identifier`
	refmethod_offset
	// cast_type_argument type in cast expression
	cast_type_argument
	// new_type_argument type argument for generic constructor in new expression or explicit constructor invocation statement
	new_type_argument
	// method_type_argument type argument for generic method in method invocation expression
	method_type_argument
	// refnew_type_argument type argument for generic constructor in method reference expression using `::new`
	refnew_type_argument
	// refmethod_type_argument type argument for generic method in method reference expression using `::Identifier`
	refmethod_type_argument
}

@[inline]
pub fn parse_target_type(target_type u8) ?TargetType {
	return match target_type {
		0, 1, 16...23, 64...75 { unsafe { TargetType(target_type) } }
		else { none }
	}
}
