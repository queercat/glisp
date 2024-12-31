extends Ast
class_name Str

var value: String

func _init(_value: String):
	self.value = _value
	self.kind = Kind.STRING

func _to_string() -> String:
	return self.value
