module structure

import shovel.reader

pub struct ResolvedMethod { // method_info
	access_flags reader.MethodAccessFlag   [required]
	name         string                    [required]
	descriptor   string                    [required]
	attributes   []reader.RawAttributeInfo [required]
}
