extends Node3D
class_name CharacterVisuals

@onready var sprite = $AnimatedSprite3D
var current_animation

func change_animation(animation_type):
	if current_animation == animation_type:
		return
	current_animation = animation_type
	sprite.play(animation_type)
