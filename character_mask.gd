extends Sprite3D
class_name CharacterMask

@export var follow_speed := 6.0
@export var max_distance := 10.0

var player
var follow_player: bool = false
@onready var parent_node: Node3D = get_parent()

func start_follow_player(player_to_follow):
	player = player_to_follow
	follow_player = true

func _physics_process(delta):
	if (follow_player == false):
		return
	var direction = player.global_position - global_position
	global_position += direction.normalized() * follow_speed * delta

	var offset = global_position - parent_node.global_position
	if offset.length() > max_distance:
		global_position = parent_node.global_position + offset.normalized() * max_distance
