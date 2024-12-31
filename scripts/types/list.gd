extends Ast
class_name List

var value

func _init(_value):
	self.value = _value
	self.kind = Kind.LIST

func _to_string() -> String:
	var strings = self.value.map(func(v): return v.to_string())
		
	return "[%s]" % ",".join(strings)
