module reader

import encoding.binary

// attribute names
pub const attr_source_file = 'SourceFile'
pub const attr_source_debug_extension = 'SourceDebugExtension'
pub const attr_inner_classes = 'InnerClasses'
pub const attr_enclosing_method = 'EnclosingMethod'
pub const attr_bootstrap_methods = 'BootstrapMethods'
pub const attr_nest_host = 'NestHost'
pub const attr_nest_members = 'NestMembers'
pub const attr_permitted_subclasses = 'PermittedSubclasses'
pub const attr_record = 'Record'
pub const attr_synthetic = 'Synthetic'
pub const attr_deprecated = 'Deprecated'
pub const attr_signature = 'Signature'
pub const attr_module = 'Module'
pub const attr_module_packages = 'ModulePackages'
pub const attr_module_main_class = 'ModuleMainClass'
pub const attr_constant_value = 'ConstantValue'
pub const attr_code = 'Code'
pub const attr_exceptions = 'Exceptions'
pub const attr_runtime_visible_parameter_annotations = 'RuntimeVisibleParameterAnnotations'
pub const attr_runtime_invisible_parameter_annotations = 'RuntimeInvisibleParameterAnnotations'
pub const attr_annotation_default = 'AnnotationDefault'
pub const attr_method_parameters = 'MethodParameters'
pub const attr_line_number_table = 'LineNumberTable'
pub const attr_local_variable_table = 'LocalVariableTable'
pub const attr_local_variable_type_table = 'LocalVariableTypeTable'
pub const attr_stack_map_table = 'StackMapTable'
pub const attr_runtime_visible_annotations = 'RuntimeVisibleAnnotations'
pub const attr_runtime_invisible_annotations = 'RuntimeInvisibleAnnotations'
pub const attr_runtime_visible_type_annotations = 'RuntimeVisibleTypeAnnotations'
pub const attr_runtime_invisible_type_annotations = 'RuntimeInvisibleTypeAnnotations'

@[heap]
pub struct RawAttributeInfo {
pub:
	attribute_name_index u16  @[required]
	info                 []u8 @[required]
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
