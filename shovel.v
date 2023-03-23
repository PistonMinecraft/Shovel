module main

// import shovel.reader
// import shovel.structure
// import shovel.structure.attribute
// import shovel.reader.version
// import shovel.reader.constant

fn main() {
	// f := reader.read([u8(0xCA), 0xFE, 0xBA, 0xBE, 0, 0, 0, 55, 0, 1]) ?
	// println(f.version)
	// println(f.constant_pool)
	mut arr := []int{cap: 10}
	arr << 1
	dump(arr)
}
