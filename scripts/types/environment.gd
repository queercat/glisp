class_name Env

var env: Dictionary
var outer: Env

func _init(keys: Array, values: Array, _outer: Env = null):
	self.env = {}
	
	for idx in range(min(keys.size(), values.size())):
		var key = keys[idx]
		var value = values[idx]
		
		if typeof(key) == typeof(Ast):	
			self.env[keys[idx].value] = values[idx]
		else:
			self.env[keys[idx]] = values[idx]
	
	self.outer = _outer

func find(symbol: String) -> Env:
	if symbol in self.env:
		return self
	
	if self.outer != null:
		return self.outer.find(symbol)

	return null

func add_signal(signal_name, value):
	self.env[signal_name] = sig.new(value, signal_name)

static func create_standard_environment() -> Env:
	var symbols = ["+", "-", "*", "/", "do", ">", "<", ">=", "<="]
	var definitions = [
		func(list): return Number.new(list.value[0].value + list.value[1].value),
		func(list): 
			if len(list.value) == 1:
				return Number.new(-list.value[0].value)
			return Number.new(list.value[0].value - list.value[1].value),
		func(list): return Number.new(list.value[0].value * list.value[1].value),
		func(list): return Number.new(list.value[0].value / list.value[1].value),
		func(list): return list.value[-1],
		func(list): return Bool.new(list.value[0].value > list.value[1].value),
		func(list): return Bool.new(list.value[0].value < list.value[1].value),
		func(list): return Bool.new(list.value[0].value >= list.value[1].value),
		func(list): return Bool.new(list.value[0].value <= list.value[1].value),
	]	
	
	return Env.new(symbols, definitions)
