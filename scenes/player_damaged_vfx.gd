extends Control
class_name  PlayerDamagedVfx
@onready var animation_player: AnimationPlayer = get_node("%AnimationPlayer")

func play_damaged_vfx():
	animation_player.play("hurt")
