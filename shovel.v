module main

import shovel.decompiler
import shovel.reader
import shovel.reader.version
import shovel.structure
import os

fn main() {
	println(version.MajorVersion.from('v23')!)
	println(int(u32(3147483647)))
	println('Hello world')
	mut class_map := structure.ClassMap.new([reader.read(os.read_bytes('MinecraftDecompilerCommandLine.class')!)!], [])
	decompiler.decompile(mut class_map)
}
