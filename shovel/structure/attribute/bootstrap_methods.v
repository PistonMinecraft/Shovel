module attribute

import shovel.reader.constant
import encoding.binary

// The `BootstrapMethods` attribute is a variable-length attribute in the `attributes`
// table of a `ClassFile` structure (§4.1). The `BootstrapMethods` attribute records
// bootstrap methods used to produce dynamically-computed constants and
// dynamically-computed call sites (§4.4.10).
// There must be exactly one `BootstrapMethods` attribute in the `attributes` table of
// a `ClassFile` structure if the `constant_pool` table of the `ClassFile` structure has
// at least one `CONSTANT_Dynamic_info` or `CONSTANT_InvokeDynamic_info` entry.
// There may be at most one `BootstrapMethods` attribute in the `attributes` table of
// a `ClassFile` structure.
// ```
// BootstrapMethods_attribute {
//   u2 attribute_name_index;
//   u4 attribute_length;
//   u2 num_bootstrap_methods;
//   { u2 bootstrap_method_ref;
//     u2 num_bootstrap_arguments;
//     u2 bootstrap_arguments[num_bootstrap_arguments];
//   } bootstrap_methods[num_bootstrap_methods];
// }
// ```
pub struct BootstrapMethod {
	// The value of the `bootstrap_method_ref` item must be a valid index into
	// the `constant_pool` table. The `constant_pool` entry at that index must be
	// a `CONSTANT_MethodHandle_info` structure (§4.4.8).
	// > The method handle will be resolved during resolution of a dynamically-computed constant or call site (§5.4.3.6), and then invoked as if by invocation
	// > of `invokeWithArguments` in `java.lang.invoke.MethodHandle`. The method
	// > handle must be able to accept the array of arguments described in §5.4.3.6, or resolution will fail.
	bootstrap_method_ref constant.ConstantMethodHandleInfo
	bootstrap_arguments  ?[]constant.Entry // constant.is_loadable(element) must be true for each `element`
}

@[direct_array_access]
pub fn read_bootstrap_methods(info []u8, pool constant.ConstantPool) ?[]BootstrapMethod {
	mut ret := []BootstrapMethod{cap: int(binary.big_endian_u16(info))}
	unsafe { ret.flags.set(.nogrow) }
	for i := 2; i < info.len; i += 2 {
		bootstrap_method_ref := pool.get_method_handle_info(binary.big_endian_u16_at(info,
			i))?
		num_bootstrap_arguments := int(binary.big_endian_u16_at(info, i + 2))
		if num_bootstrap_arguments == 0 {
			ret << BootstrapMethod{bootstrap_method_ref, none}
		} else {
			if info.len - i < 2 + num_bootstrap_arguments * 2 {
				return none
			}
			mut bootstrap_arguments := []constant.Entry{len: num_bootstrap_arguments, init: constant.Entry(constant.InvalidConstantInfo{})}
			unsafe { bootstrap_arguments.flags.set(.nogrow) }
			for j := 0; j < num_bootstrap_arguments; j++ {
				i += 2
				bootstrap_arguments[j] = pool.get_loadable_info(binary.big_endian_u16_at(info,
					i))?
			}
			ret << BootstrapMethod{bootstrap_method_ref, bootstrap_arguments}
		}
	}
	return ret
}
