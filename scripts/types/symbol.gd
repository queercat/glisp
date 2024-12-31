extends Ast
class_name Symbol

var value: String

func _init(_value: String):
	self.value = _value
	self.kind = Kind.SYMBOL

func _to_string() -> String:
	return "%s" % self.value
