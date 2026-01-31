extends Area3D
var target_node : Node3D 

func _ready():
	target_node = get_node("%HeadText") 
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		target_node.visible = true
		target_node.process_mode = Node.PROCESS_MODE_INHERIT

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		target_node.visible = false
		target_node.process_mode = Node.PROCESS_MODE_DISABLED
