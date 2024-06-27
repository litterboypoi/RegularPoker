class_name Player
extends Node2D

signal die(player: Player)

var is_my_turn: bool = false

@export var health: int = 10
var shield: int = 0
@export var skills: Array[SkillCardData] = []
var skill_cards: Array[SkillCard] = []
@onready var cards: Cards = $Cards
@onready var skills_position_node = $SkillsPosition

var skill_card_packed_scene = preload("res://skills/skill_card.tscn")

func _ready():
	render_skill_cards()

func render_skill_cards():
	for i in range(skills.size()):
		var skill_card = render_skill_card(skills[i])
		add_child(skill_card)
		skill_card.position = Vector2(i * 50 - skills.size() * 50 / 2, 0) + skills_position_node.position
		skill_cards.append(skill_card)

func render_skill_card(skill_card_data: SkillCardData):
	var skill_card = skill_card_packed_scene.instantiate() as SkillCard
	skill_card.skill_card_data = skill_card_data
	return skill_card

func draw_card(card: CardData):
	cards.append(card)

func play_card(card: CardData):
	cards.remove(card)

func start_turn():
	is_my_turn = true

func can_end_turn() -> bool:
	return true

func end_turn():
	is_my_turn = false

func take_damage(damage: int):
	if shield >= damage:
		shield -= damage
	else:
		shield = 0
		health -= maxi(damage - shield, health)
	if health == 0:
		deal_die()
	
func deal_die():
	emit_signal('die', self)
