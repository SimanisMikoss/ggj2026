extends Control

var item_visual: TextureRect
var hand_visuals: TextureRect
var interact_text: Label

func _ready():
	item_visual = get_node("%ItemInHands") 
	interact_text = get_node("%InteractLabel")
	hand_visuals = get_node("%HandVisuals")
