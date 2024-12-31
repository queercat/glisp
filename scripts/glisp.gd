class_name Glisp

static func is_symbol(character: String) -> bool:
	match character:
		"(": return true
		")": return true
		_: return false

static func is_letter(character: String) -> bool:
	match character:
		"!": return true
		"#": return true
		"'": return true
		"@": return true
		"^": return true
		"+": return true
		"-": return true
		"/": return true
		"*": return true
		"?": return true
		"_": return true
		">": return true
		"<": return true
		"=": return true
	
	var value = character.unicode_at(0)
	
	if value >= "a".unicode_at(0) and value <= "z".unicode_at(0):
		return true
	elif value >= "A".unicode_at(0) and value <= "Z".unicode_at(0):
		return true
	elif value >= "0".unicode_at(0) and value <= "9".unicode_at(0):
		return true
	
	return false

static func is_number(character: String) -> bool:
	var value = character.unicode_at(0)
	return value >= "0".unicode_at(0) and value <= "9".unicode_at(0)

static func tokenize(source: String) -> Array[Token]:
	var tokens: Array[Token] = []
	
	var left = 0
	var start = 0

	var position = Vector2(0, 0)

	while left < source.length():
		var character = source[left]
		var token = null
				
		match character:
			"\r":
				position.y += 1
				left += 1
			"\t":
				position.y += 1
				left += 1
			"\n":
				position.x += 1
				position.y = 0
				left += 1
			" ":
				position.y += 1
				left += 1
			# String
			"\"":
				start = left
				left += 1
				while (left < source.length() and source[left] != "\""):
					left += 1
				if left < source.length() and source[left] != "\"":
					assert("Expected end of string but found %s instead (%s, %s)" % [character, position.x, position.y] == null)
				elif left >= source.length():
					assert("Expected end of string but found %s instead (%s, %s)" % [character, position.x, position.y] == null)
				left += 1
				token = Token.new(source.substr(start + 1, left - start - 2), Token.Kind.STRING, position)
				position.y += (left - start)
			# Number
			_ when is_number(character):
				start = left
				while (left < source.length() and is_number(source[left])):
					left += 1
				token = Token.new(source.substr(start, left - start), Token.Kind.NUMBER, position)
				position.y += (left - start)
			# Symbol
			_ when is_letter(character):
				start = left
				while (left < source.length() and is_letter(source[left])):
					left += 1
				token = Token.new(source.substr(start, left - start), Token.Kind.SYMBOL, position)
				position.y += (left - start)
			# Also a symbol... Maybe there shouldn't be any difference lol?
			_ when is_symbol(character):
				token = Token.new(character, Token.KindMap[character], position)
				left += 1
				position.y += 1
			_: assert(
				"Invalid character -> { %s } <- found (%s, %s)" 
				% [character, position.x, position.y] == null
			)
		# == END MATCH ==
		if token != null:
			tokens.append(token)
			
	return tokens

static func parse(tokens: Array[Token]) -> Ast:
	assert(tokens.size() > 0)
	
	var token: Token = tokens.pop_front()
	
	if token.kind == Token.Kind.LPAREN:
		var list: Array[Ast] = []
		
		while tokens[0].kind != Token.Kind.RPAREN:
			list.append(parse(tokens))
		
		tokens.pop_front()
		
		return List.new(list)

	match token.kind:
		Token.Kind.STRING: return Str.new(token.text)
		Token.Kind.NUMBER: return Number.new(float(token.text))
		Token.Kind.SYMBOL: 
			if token.text == "true": return Bool.new(true)
			elif token.text == "false": return Bool.new(false)
			return Symbol.new(token.text)
		_: return null

static func eval(ast: Ast, env: Env):
	match ast.kind:
		ast.Kind.SYMBOL: 
			var found = env.find(ast.value)
			assert(found != null)
			return found.env[ast.value]
		ast.Kind.LIST: pass
		_: return ast	
	
	if len(ast.value) == 0:
		return null
	
	# Special forms
	if ast.value[0].kind == Ast.Kind.SYMBOL and ast.value[0].value == "?":
		var test = eval(ast.value[1], env)
		var tested = false
				
		match test.kind:
			Ast.Kind.NUMBER: tested = test.value > 0
			Ast.Kind.BOOL: tested = test.value
			Ast.Kind.STRING: tested = test.value.length() > 0
			_: false
		
		var left = ast.value[2]
		var right = ast.value[3]
		
		var expression = left if tested else right
		
		return eval(expression, env)
	elif ast.value[0].kind == Ast.Kind.SYMBOL and ast.value[0].value == "let":
		var symbol = ast.value[1]
		var expression = ast.value[2]
		
		assert(symbol.kind == Ast.Kind.SYMBOL)
		
		env.env[symbol.value] = eval(expression, env)
		
		return env.env[symbol.value]	
	elif ast.value[0].kind == Ast.Kind.SYMBOL and ast.value[0].value == "quote":
		var expression = ast.value[1]
		return expression
	elif ast.value[0].kind == Ast.Kind.SYMBOL and ast.value[0].value == "unquote":
		return eval(ast.value[1], env)
	elif ast.value[0].kind == Ast.Kind.SYMBOL and ast.value[0].value == "lambda":
		var arguments = ast.value[1]
		var expression = ast.value[2]
	
		return Function.new(arguments, expression, env)
	
	var funk = eval(ast.value[0], env)
	var arguments = List.new(ast.value.slice(1).map(func(e): return eval(e, env)))
	
	if typeof(funk) != typeof(Ast):
		return funk.call(arguments)
	else:
		return funk._call(arguments)
