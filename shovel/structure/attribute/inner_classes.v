module attribute

import shovel.reader.constant
import shovel.reader
import encoding.binary

// If the constant pool of a class or interface `C` contains at least one
// `CONSTANT_Class_info`(shovel.reader.constant.ConstantClassInfo) entry which represents a class or interface that is
// not a member of a package, then there must be **exactly one** `InnerClasses` attribute
// in the `attributes` table of the `ClassFile` structure for `C`.
// ```
// InnerClasses_attribute {
//  u2 attribute_name_index;
//  u4 attribute_length;
//  u2 number_of_classes;
//  { u2 inner_class_info_index;
//    u2 outer_class_info_index;
//    u2 inner_name_index;
//    u2 inner_class_access_flags;
//  } classes[number_of_classes];
// }
// ```
pub struct InnerClass {
	// Full name of this inner class
	//
	// The value of the `inner_class_info_index` item must be a valid index into
	// the `constant_pool` table. The `constant_pool` entry at that index must be
	// a `CONSTANT_Class_info` structure representing `C`.
	inner_class_info constant.ConstantClassInfo [required]
	// Full name of the outer class of this inner class
	// `none` if `inner_class_info` is a top-level class or interface or a local class or
	// an anonymous class or inner_name is `none`
	//
	// If `C` is not a member of a class or an interface - that is, if `C` is a top-level
	// class or interface (JLS §7.6) or a local class (JLS §14.3) or an anonymous
	// class (JLS §15.9.5) - then the value of the `outer_class_info_index` item must be zero.
	// Otherwise, the value of the `outer_class_info_index` item must be a valid
	// index into the `constant_pool` table, and the entry at that index must be
	// a `CONSTANT_Class_info` structure representing the class or interface of
	// which `C` is a member. The value of the `outer_class_info_index` item
	// must not equal the the value of the `inner_class_info_index` item.
	//
	// If a `class` file has a version number that is 51.0(MajorVersion.v7) or above, and
	// has an `InnerClasses` attribute in its `attributes` table, then for all
	// entries in the `classes` array of the `InnerClasses` attribute, the value
	// of the `outer_class_info_index` item must be zero if the value of the
	// `inner_name_index` item is zero.
	outer_class_info ?constant.ConstantClassInfo
	// Actual name of this inner class
	// `none` if `inner_class_info` is anonymous
	//
	// If `C` is anonymous (JLS §15.9.5), the value of the `inner_name_index` item must be zero.
	// Otherwise, the value of the `inner_name_index` item must be a valid index
	// into the `constant_pool` table, and the entry at that index must be a
	// `CONSTANT_Utf8_info` structure that represents the original simple name of
	// `C`, as given in the source code from which this class file was compiled.
	inner_name ?string
	// Access flags of this inner class
	//
	// The value of the `inner_class_access_flags` item is a mask of flags used
	// to denote access permissions to and properties of class or interface `C` as
	// declared in the source code from which this class file was compiled. It is
	// used by a compiler to recover the original information when source code is not available.
	inner_class_access_flags reader.ClassAccessFlag
}

[direct_array_access]
pub fn read_inner_classes(info []u8, pool constant.ConstantPool) ?[]InnerClass {
	mut ret := []InnerClass{len: int(binary.big_endian_u16(info))}
	if info.len < 2 + ret.len * 8 {
		return none
	}
	for i := 2; i < info.len; i += 8 {
		ret << InnerClass{
			inner_class_info: pool.get_class_info(binary.big_endian_u16_at(info, i))?
			outer_class_info: pool.get_class_info(binary.big_endian_u16_at(info, i + 2))
			inner_name: pool.get_utf8(binary.big_endian_u16_at(info, i + 4))
			inner_class_access_flags: reader.ClassAccessFlag(binary.big_endian_u16_at(info,
				i + 6))
		}
	}
	return ret
}
