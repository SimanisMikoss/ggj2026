extends Node3D
class_name CharacterVisuals

var current_animation
@onready var animated_sprites: Array
var my_sprite: AnimatedSprite3D

var base_anim := "angry"

func _ready() -> void:
	animated_sprites = get_children()
	
	
	for i in animated_sprites.size():
		animated_sprites[i].visible = false
		
	my_sprite = animated_sprites.pick_random()
	my_sprite.visible = true
	my_sprite.animation_finished.connect(_on_animation_finished)

func change_animation(animation_type):
	print("trying to play ", animation_type)
	if current_animation == animation_type:
		return
	current_animation = animation_type
	for sprite in animated_sprites:
		sprite.play(animation_type)
	
#func play_once(anim_name: String):
  #  anim.play(anim_name)


func _on_animation_finished():
	print("attack animation finished")
	#my_sprite.play(base_anim)
			
		#anim.play(base_anim)
