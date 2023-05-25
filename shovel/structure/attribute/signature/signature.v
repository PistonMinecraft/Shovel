module signature

// BaseType:
//   (one of)
// 	 B C D F I J S Z
// ReferenceTypeSignature:
//   ClassTypeSignature
//   TypeVariableSignature
//   ArrayTypeSignature
// JavaTypeSignature:
//   ReferenceTypeSignature
//   BaseType
//
// PackageSpecifier:
//   Identifier / {PackageSpecifier}

pub interface Signature {
	raw string
}
