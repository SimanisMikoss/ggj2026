extends Button

func _ready():
	self.pressed.connect(_on_button_pressed)

func _on_button_pressed():
	print("Button was pressed!")
	Global.input_allowed = true
	get_tree().reload_current_scene()
