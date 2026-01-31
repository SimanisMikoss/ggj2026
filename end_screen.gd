extends Control
@export var end_screen_delay: float

@onready var victory_animation:  AnimationPlayer = get_node("%VictoryAnimation")
@onready var defeat_animation: AnimationPlayer = get_node("%DefeatAnimation")

func show_end_screen(victory: bool):
	if victory == true:
		victory_animation.play("victory")
	else:
		defeat_animation.play("defeat")
