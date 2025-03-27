module code

import shovel.reader.constant

pub struct ExceptionTableEntry {
pub:
	start_pc   u16
	end_pc     u16
	handler_pc u16
	catch_type ?constant.ConstantClassInfo
}

pub struct LineNumber {
pub:
	start_pc    u16
	line_number u16
}

pub struct LocalVariable {
pub:
	start_pc   u16
	length     u16
	name       string
	descriptor string
	index      u16
}

pub struct LocalVariableType {
pub:
	start_pc  u16
	length    u16
	name      string
	signature string
	index     u16
}
