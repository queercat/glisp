class_name Token

enum Kind { 
	LPAREN, 
	RPAREN,
	STRING, 
	NUMBER,
	SYMBOL, 
}

static var KindMap = {
	"(": Kind.LPAREN,
	")": Kind.RPAREN,

}

var text: String
var kind: Kind
var position: Vector2

func _init(_text: String, _kind: Kind, _position: Vector2):
	self.text = _text
	self.kind = _kind
	self.position = _position

func _to_string() -> String:
	return "<%s:%s (%s, %s)>" % [self.text, self.kind, self.position.x, self.position.y]
