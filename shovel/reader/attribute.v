module reader

import encoding.binary

// attribute names
pub const (
	attr_source_file                             = 'SourceFile'
	attr_source_debug_extension                  = 'SourceDebugExtension'
	attr_inner_classes                           = 'InnerClasses'
	attr_enclosing_method                        = 'EnclosingMethod'
	attr_bootstrap_methods                       = 'BootstrapMethods'
	attr_nest_host                               = 'NestHost'
	attr_nest_members                            = 'NestMembers'
	attr_permitted_subclasses                    = 'PermittedSubclasses'
	attr_record                                  = 'Record'
	attr_synthetic                               = 'Synthetic'
	attr_deprecated                              = 'Deprecated'
	attr_signature                               = 'Signature'
	attr_module                                  = 'Module'
	attr_module_packages                         = 'ModulePackages'
	attr_module_main_class                       = 'ModuleMainClass'
	attr_constant_value                          = 'ConstantValue'
	attr_code                                    = 'Code'
	attr_exceptions                              = 'Exceptions'
	attr_runtime_visible_parameter_annotations   = 'RuntimeVisibleParameterAnnotations'
	attr_runtime_invisible_parameter_annotations = 'RuntimeInvisibleParameterAnnotations'
	attr_annotation_default                      = 'AnnotationDefault'
	attr_method_parameters                       = 'MethodParameters'
	attr_runtime_visible_annotations             = 'RuntimeVisibleAnnotations'
	attr_runtime_invisible_annotations           = 'RuntimeInvisibleAnnotations'
	attr_runtime_visible_type_annotations        = 'RuntimeVisibleTypeAnnotations'
	attr_runtime_invisible_type_annotations      = 'RuntimeInvisibleTypeAnnotations'
)

pub struct RawAttributeInfo {
pub:
	attribute_name_index u16  [required]
	info                 []u8 [required]
}

pub fn read_attribute_info(b []u8, count u16, mut offset &int) []RawAttributeInfo {
	mut info_arr := []RawAttributeInfo{len: int(count)}
	for i in 0 .. count {
		off := *offset
		len := int(binary.big_endian_u32_at(b, off + 2))
		if len < 0 { // potential overflow
			panic('number overflow')
		}
		info_arr[i] = RawAttributeInfo{binary.big_endian_u16_at(b, off), b[off + 6..off + 6 + len]}
		offset += 6 + len
	}
	return info_arr
}
