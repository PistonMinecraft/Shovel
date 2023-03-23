module structure

import shovel.reader

pub struct ResolvedField {
	access_flags reader.FieldAccessFlag    [required]
	name         string                    [required]
	descriptor   string                    [required]
	attributes   []reader.RawAttributeInfo [required]
}
