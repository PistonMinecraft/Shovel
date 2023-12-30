module signature

// ```
// BaseType:
//   (one of)
// 	 B C D F I J S Z
// ```
// A Java type signature represents either a reference type or a primitive type of
// the Java programming language.
// ```
// JavaTypeSignature:
//   ReferenceTypeSignature
//   BaseType
// ```
// A reference type signature represents a reference type of the Java programming
// language, that is, a class or interface type, a type variable, or an array type.
// ```
// ReferenceTypeSignature:
//   ClassTypeSignature
//   TypeVariableSignature
//   ArrayTypeSignature
// ```
// A class type signature represents a (possibly parameterized) class or interface
// type. A class type signature must be formulated such that it can be reliably
// mapped to the binary name of the class it denotes by erasing any type arguments
// and converting each . character to a $ character.
// ```
// ClassTypeSignature:
//   L [PackageSpecifier] SimpleClassTypeSignature {ClassTypeSignatureSuffix} ;
// PackageSpecifier:
//  Identifier / {PackageSpecifier}
// SimpleClassTypeSignature:
//   Identifier [TypeArguments]
// TypeArguments:
//   < TypeArgument {TypeArgument} >
// TypeArgument:
//   [WildcardIndicator] ReferenceTypeSignature
//   *
// WildcardIndicator:
//   +
//   -
// ClassTypeSignatureSuffix:
//   . SimpleClassTypeSignature
// ```
// A type variable signature represents a type variable.
// ```
// TypeVariableSignature:
//   T Identifier ;
// ```
// An array type signature represents one dimension of an array type.
// ```
// ArrayTypeSignature:
//   [ JavaTypeSignature
// ```
//
pub interface Signature { // TODO: low priority
	raw string
}
