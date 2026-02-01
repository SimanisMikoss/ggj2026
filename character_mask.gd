extends Sprite3D
class_name CharacterMask

@export var follow_speed :float
@export var max_distance : float

var player
var follow_player: bool = false
@onready var parent_node: Node3D = get_parent()

func start_follow_player(player_to_follow, mask_pickup: MaskPickup):
	player = player_to_follow
	parent_node.global_position += mask_pickup.mask_offset_on_character
	follow_player = true

func _physics_process(delta):
	if (follow_player == false):
		return
	var direction = player.global_position - global_position
	global_position += direction.normalized() * follow_speed * delta

	var offset = global_position - parent_node.global_position
	if offset.length() > max_distance:
		global_position = parent_node.global_position + offset.normalized() * max_distance
