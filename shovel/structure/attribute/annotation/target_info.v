module annotation

pub type TargetInfo = CatchTarget
	| EmptyTarget
	| FormalParameterTarget
	| LocalVarTarget
	| OffsetTarget
	| SuperTypeTarget
	| ThrowsTarget
	| TypeArgumentTarget
	| TypeParameterBoundTarget
	| TypeParameterTarget

// The `type_parameter_target` item indicates that an annotation appears on the
// declaration of the _i_'th type parameter of a generic class, generic interface, generic
// method, or generic constructor.
// ```
// type_parameter_target {
//   u1 type_parameter_index;
//}
// ```
pub struct TypeParameterTarget {
	// index The value of the `type_parameter_index` item specifies which type parameter
	// declaration is annotated. A `type_parameter_index` value of `0` specifies the first
	// type parameter declaration.
	index u8
}

// The `supertype_target` item indicates that an annotation appears on a type in
// the `extends` or `implements` clause of a class or interface declaration.
// ```
// supertype_target {
//   u2 supertype_index;
//}
// ```
pub struct SuperTypeTarget {
	// index A `supertype_index` value of 65535 specifies that the annotation appears on the
	// superclass in an `extends` clause of a class declaration.
	// Any other `supertype_index` value is an index into the `interfaces` array of
	// the enclosing `ClassFile` structure, and specifies that the annotation appears on
	// that superinterface in either the `implements` clause of a class declaration or the
	// extends clause of an interface declaration.
	index u16
}

// The `type_parameter_bound_target` item indicates that an annotation appears
// on the _i_'th bound of the _j_'th type parameter declaration of a generic class,
// interface, method, or constructor.
//
// _The `type_parameter_bound_target` item records that a bound is annotated, but does
// not record the type which constitutes the bound. The type may be found by inspecting
// the class signature or method signature stored in the appropriate `Signature` attribute._
pub struct TypeParameterBoundTarget {
	// type_parameter_index The value of the of `type_parameter_index` item specifies which type parameter
	// declaration has an annotated bound. A `type_parameter_index` value of `0`
	// specifies the first type parameter declaration.
	type_parameter_index u8
	// bound_index The value of the `bound_index` item specifies which bound of the type parameter
	// declaration indicated by `type_parameter_index` is annotated. A `bound_index`
	// value of `0` specifies the first bound of a type parameter declaration
	bound_index u8
}

pub const empty_target = EmptyTarget{}

// The `empty_target` item indicates that an annotation appears on either the type
// in a field declaration, the type in a record component declaration, the return type
// of a method, the type of a newly constructed object, or the receiver type of a
// method or constructor.
//
// _Only one type appears in each of these locations, so there is no per-type information to
// represent in the `target_info` union._
pub struct EmptyTarget {
}

// The `formal_parameter_target` item indicates that an annotation appears on
// the type in a formal parameter declaration of a method, constructor, or lambda
// expression.
//
// _The `formal_parameter_target` item records that a formal parameter's type is
// annotated, but does not record the type itself. The type may be found by inspecting the
// method descriptor, although a `formal_parameter_index` value of 0 does not always
// indicate the first parameter descriptor in the method descriptor; see the note in §4.7.18
// for a similar situation involving the `parameter_annotations` table._
pub struct FormalParameterTarget {
	// index The value of the `formal_parameter_index` item specifies which formal
	// parameter declaration has an annotated type. A `formal_parameter_index` value
	// of _i_ may, but is not required to, correspond to the _i_'th parameter descriptor in the
	// method descriptor (§4.3.3).
	index u8
}

// The `throws_target` item indicates that an annotation appears on the _i_'th type in
// the `throws` clause of a method or constructor declaration.
pub struct ThrowsTarget {
	// type_index The value of the `throws_type_index` item is an index into the
	// `exception_index_table` array of the `Exceptions` attribute of the `method_info`
	// structure enclosing the `RuntimeVisibleTypeAnnotations` attribute.
	type_index u16
}

pub struct LocalVarTableEntry {
	// start_pc,length The given local variable has a value at indices into the `code` array in
	// the interval `[start_pc, start_pc + length)`, that is, between `start_pc`
	// inclusive and `start_pc + length` exclusive.
	start_pc u16
	length   u16
	// index The given local variable must be at `index` in the local variable array of the current frame.
	//
	// If the local variable at `index` is of type `double` or `long`, it occupies both `index` and `index + 1`.
	//
	// _A table is needed to fully specify the local variable whose type is annotated, because
	// a single local variable may be represented with different local variable indices over
	// multiple live ranges. The `start_pc`, `length`, and `index` items in each table entry
	// specify the same information as a `LocalVariableTable` attribute._
	//
	// _The `localvar_target` item records that a local variable's type is annotated, but
	// does not record the type itself. The type may be found by inspecting the appropriate
	// `LocalVariableTable` attribute._
	index u16
}

// The `localvar_target` item indicates that an annotation appears on the type in
// a local variable declaration, including a variable declared as a resource in a `try`-with-resources statement
pub struct LocalVarTarget {
	// table The value of the `table_length` item gives the number of entries in the `table`
	// array. Each entry indicates a range of `code` array offsets within which a local
	// variable has a value. It also indicates the index into the local variable array of
	// the current frame at which that local variable can be found.
	table []LocalVarTableEntry
}

// The `catch_target` item indicates that an annotation appears on the _i_'th type in an exception parameter declaration.
//
// _The possibility of more than one type in an exception parameter declaration arises from
// the multi-`catch` clause of the `try` statement, where the type of the exception parameter
// is a union of types (JLS §14.20). A compiler usually creates one `exception_table`
// entry for each type in the union, which allows the `catch_target` item to distinguish
// them. This preserves the correspondence between a type and its annotations._
pub struct CatchTarget {
	// exception_table_index The value of the `exception_table_index` item is an index into
	// the `exception_table` array of the `Code` attribute enclosing the
	// `RuntimeVisibleTypeAnnotations` attribute.
	exception_table_index u16
}

// The `offset_target` item indicates that an annotation appears on either the type
// in an _instanceof_ expression or a _new_ expression, or the type before the `::` in a
// method reference expression.
pub struct OffsetTarget {
	// offset The value of the `offset` item specifies the `code` array offset of either the bytecode
	// instruction corresponding to the _instanceof_ expression, the _new_ bytecode
	// instruction corresponding to the _new_ expression, or the bytecode instruction
	// corresponding to the method reference expression.
	offset u16
}

// The `type_argument_target` item indicates that an annotation appears either on
// the _i_'th type in a cast expression, or on the _i_'th type argument in the explicit type
// argument list for any of the following: a _new_ expression, an explicit constructor
// invocation statement, a method invocation expression, or a method reference expression.
pub struct TypeArgumentTarget {
	// offset The value of the `offset` item specifies the `code` array offset of either the
	// bytecode instruction corresponding to the cast expression, the _new_ bytecode
	// instruction corresponding to the _new_ expression, the bytecode instruction
	// corresponding to the explicit constructor invocation statement, the bytecode
	// instruction corresponding to the method invocation expression, or the bytecode
	// instruction corresponding to the method reference expression.
	offset u16
	// type_argument_index For a cast expression, the value of the `type_argument_index` item specifies
	// which type in the cast operator is annotated. A `type_argument_index` value of
	// `0` specifies the first (or only) type in the cast operator.
	//
	// _The possibility of more than one type in a cast expression arises from a cast to an
	// intersection type._
	//
	// For an explicit type argument list, the value of the `type_argument_index` item
	// specifies which type argument is annotated. A `type_argument_index` value of
	// `0` specifies the first type argument.
	type_argument_index u8
}
