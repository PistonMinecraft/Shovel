module code

import shovel.reader.constant

pub struct ExceptionTableEntry {
	start_pc   u16
	end_pc     u16
	handler_pc u16
	catch_type ?constant.ConstantClassInfo
}

pub struct LineNumber {
	start_pc    u16
	line_number u16
}

pub struct LocalVariable {
	start_pc   u16
	length     u16
	name       string
	descriptor string
	index      u16
}

pub struct LocalVariableType {
	start_pc  u16
	length    u16
	name      string
	signature string
	index     u16
}
