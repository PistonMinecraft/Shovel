module code

pub struct ExceptionTableEntry {
	start_pc   u16
	end_pc     u16
	handler_pc u16
	catch_type u16
}
