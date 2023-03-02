module constant

[direct_array_access]
pub fn parse_utf8_info(bytes []u8, offset int, length u16) !string {
	if length == 0 {
		return ''
	}
	mut ret := []u8{len: int(length) / 2, cap: int(length) + 1}
	end := offset + length
	for i := offset; i < end; i++ {
		b := bytes[i]
		if (b >> 4) == u8(0b1110) && bytes.len >= i + 6 {
			high := read3(bytes, i)
			if is_high_surrogate(high) {
				low := read3(bytes, i + 3)
				if _likely_(is_low_surrogate(low)) {
					cp := to_code_point(high, low)
					ret << (u8(0b11110) + (u8(cp >> 18) & 0b111))
					ret << (u8(0b10) + (u8(cp >> 12) & 0b111111))
					ret << (u8(0b10) + (u8(cp >> 6) & 0b111111))
					ret << (u8(0b10) + (u8(cp) & 0b111111))
					i += 6
					continue
				}
			}
		} else if _unlikely_(b == u8(0xC0) && bytes[i + 1] == u8(0x80)) {
			ret << u8(0) // WARNING: potential C interoperability breaking
			i++
			continue
		}
		ret << b
	}
	ret << u8(0) // C interoperability
	return unsafe { string{
		str: &ret
		len: ret.len - 1 // exclude the ending \0
	} }
}

[inline; direct_array_access]
fn read3(arr []u8, o int) u16 {
	return (u16(arr[o] & 0xf) << 12) + (u16(arr[o + 1] & 0x3f) << 6) + u16(arr[o + 2] & 0x3f)
}

// ported from Character.java

[inline]
fn is_high_surrogate(c u16) bool {
	return c >= 0xD800 && c <= 0xDBFF
}

[inline]
fn is_low_surrogate(c u16) bool {
	return c >= 0xDC00 && c <= 0xDFFF
}

[inline]
fn to_code_point(high u16, low u16) u32 {
	// MIN_SUPPLEMENTARY_CODE_POINT = 0x010000
	// MIN_HIGH_SURROGATE = '\uD800'
	// MIN_LOW_SURROGATE = '\uDC00'
	// Optimized form of:
	// return ((high - MIN_HIGH_SURROGATE) << 10)
	//         + (low - MIN_LOW_SURROGATE)
	//         + MIN_SUPPLEMENTARY_CODE_POINT;
	return ((high << 10) + low) + (0x010000 - (0xD800 << 10) - 0xDC00)
}
