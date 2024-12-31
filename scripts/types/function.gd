extends Ast
class_name Function

var arguments: Ast
var expression: Ast
var env: Env

func _init(_arguments: Ast, _expression: Ast, _env: Env):
	self.arguments = _arguments
	self.expression = _expression
	self.env = _env
	
	self.kind = Kind.FUNCTION

func _to_string() -> String:
	return "lambda: arguments -> [%s] expression -> [%s]" % [self.arguments, self.expression]

func _call(_arguments: Ast):
	var new_env = Env.new(self.arguments.value, _arguments.value, self.env)
	return Glisp.eval(self.expression, new_env)
