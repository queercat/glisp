extends Ast
class_name sig

var value
var name

func _init(_value, _name) -> void:
	self.value = _value
	self.name = _name
	self.kind = Ast.Kind.SIGNAL

func _call(args = null):
	if args != null and args.value.size() > 0:
		self.value.emit(args.value[0].value)
		return self
	else:
		self.value.emit()
		return self

func _to_string() -> String:
	return "signal: [%s]" % self.name
