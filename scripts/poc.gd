extends Node3D

signal trigger_door_open(passcode)

var passcode

func _init() -> void:
	trigger_door_open.connect(open_door)
	self.passcode = randi_range(100, 200)

func _ready() -> void:
	$Editor.add_signal("signal-door", trigger_door_open)
	
func open_door(passcode):
	if passcode == self.passcode:
		$Door_A_Decorated2.rotate(Vector3(0, 1, 0), deg_to_rad(-90))
		$Editor.message.emit("Passcode %s is valid!" % passcode)
	else:
		$Editor.message.emit("Wrong passcode!")

func close_door():
	$Door_A_Decorated2.rotate(Vector3(0, 1, 0), deg_to_rad(90))

func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_E):
		on_interact()
	elif Input.is_key_pressed(KEY_ESCAPE):
		on_exit()

func on_exit():
	$"Editor".visible = false
	$"Pawn".Locked = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func on_interact():
	$"Editor".visible = true
	$"Pawn".Locked = true
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
