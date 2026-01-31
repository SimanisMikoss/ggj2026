extends Node3D

var mask_pickup: Area3D

func _ready():
	mask_pickup = get_node("Area3D") 
