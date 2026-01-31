extends Node

var AnimationType : Array = [ "default", "angry", "happy" ]

	
signal game_ended()

var input_allowed: bool = true:
	set(value):
		input_allowed = value
		if (value == false):
			game_ended.emit()
