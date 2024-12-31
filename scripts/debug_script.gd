extends Control

signal message(text)

var env

func _init():
	message.connect(write)

func write(message):
	$CodeEdit2.text += message + "\n"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Button.button_down.connect(run)
	self.env = Env.create_standard_environment()


func add_signal(signal_name, value):
	self.env.add_signal(signal_name, value)

func run():
	var text = $CodeEdit.text
	var tokens = Glisp.tokenize(text)
	var ast = Glisp.parse(tokens)

	var result = Glisp.eval(ast, self.env)
	$CodeEdit2.text += "> " + result.to_string() + "\n"
