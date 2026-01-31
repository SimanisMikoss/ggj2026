extends Control
@export var end_screen_delay: float

func show_end_screen(victory: bool):
	var victory_animation = get_node("%VictoryAnimation")
	var defeat_animation: AnimationPlayer = get_node("%DefeatAnimation")
	if victory == true:
		defeat_animation.get_parent().visible = false
		victory_animation.play("victory")
		
	else:
		victory_animation.get_parent().visible = false
		defeat_animation.play("defeat")
