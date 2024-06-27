class_name Card
extends Node2D

# 职责为响应游戏的交互，如点击、拖拽。播放卡牌的动画效果

# must be set before add to scene tree
@export var card_data: CardData

@onready var sprite: Sprite2D = $Sprite2D

@onready var area2d: Area2D = $Area2D

func _ready():
	if card_data.appreance:
		sprite.texture = card_data.appreance
		sprite.visible = true
	if card_data.special_appreance:
		var appreance_node = card_data.special_appreance.instantiate()
		add_child(appreance_node)

func get_overlapping_areas() -> Array[Area2D]:
	return area2d.get_overlapping_areas()
