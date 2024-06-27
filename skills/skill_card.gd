class_name SkillCard
extends Node2D

@export var skill_card_data: SkillCardData

var is_charged = false

@onready var title_ui = %Title
@onready var desc_ui = %Desc
@onready var draggable: Draggable = $Draggable
@onready var sprite2d: Sprite2D = $Sprite2D

func _ready():
	title_ui.text = skill_card_data.title
	desc_ui.text = skill_card_data.desc
	#draggable.dragging_action = Draggable.DRAGGING_ACTION.PLAY_SKILL

func apply_skill(target):
	for effect in skill_card_data.effects:
		effect.apply(target)
	is_charged = false
	sprite2d.modulate = Color(1,1,1,1)

func try_charge_skill(card_datas: Array[CardData]):
	var is_match = check_is_pattern_match(card_datas)
	if is_match and not is_charged:
		is_charged = true
		sprite2d.modulate = Color(0, 0, 1, 0.3)
		return true
	return false

func check_is_pattern_match(card_datas: Array[CardData]):
	return skill_card_data.pattern.is_match(card_datas)
