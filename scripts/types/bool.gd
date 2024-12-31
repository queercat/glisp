extends Ast
class_name Bool

var value: bool

func _init(_value: bool):
	self.value = _value
	self.kind = Kind.BOOL

func _to_string() -> String:
	return "true" if self.value else "false"
