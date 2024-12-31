extends Ast
class_name Number

var value: float

func _init(_value: float):
	self.value = _value
	self.kind = Kind.NUMBER

func _to_string() -> String:
	return "%s" % self.value
