module main

// import shovel.decompiler
import shovel.reader
import shovel.reader.constant
import shovel.reader.version
// import shovel.structure
// import shovel.structure.attribute
// import shovel.structure.attribute.annotation
// import shovel.structure.attribute.modules
// import shovel.utils

fn main() {
	mut off := 1
	constant.read_cp([u8(0)], u16(1), mut &off)!
}
