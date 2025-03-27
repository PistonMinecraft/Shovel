module main

import shovel.decompiler
import shovel.reader
import shovel.structure
import os

fn main() {
	cls := reader.read(os.read_bytes('test_cases/MinecraftDecompilerCommandLine.class')!)!
	mut class_map := structure.ClassMap.new([cls], [])
	decompiler.decompile(mut class_map)
}
