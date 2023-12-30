module code

import shovel.reader.constant

pub type StackMapFrame = u16

pub fn read_stack_map_table(info []u8, pool constant.ConstantPool) ?[]StackMapFrame {
	return none // TODO
}
