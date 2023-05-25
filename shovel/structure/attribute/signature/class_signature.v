module signature

// ClassSignature:
//     [TypeParameters] SuperclassSignature {SuperinterfaceSignature}
pub struct ClassSignature {
	raw         string
	this_class  string
	super_class string
	interfaces  ?[]string
}
