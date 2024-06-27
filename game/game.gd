class_name Game
extends Node2D

var packed_player = preload("res://players/player.tscn")

var all_cards: Array[CardData] = []
var draw_pile: Array[CardData] = []
var discard_pile: Array[CardData] = []

var selected_cards: Array[Card] = []

var players: Array[Player] = []
var current_player: Player

@onready var play_area: PlayArea = $PlayArea

var selected_play_card: Card
var selected_play_card_origin_global_position: Vector2
var selected_play_card_offset: Vector2 = Vector2.ZERO

var drag_selected_cards = false
var selected_cards_origin_positions = []
var click_start_mouse_positon: Vector2 = Vector2.ZERO

var dragging_skill_card: SkillCard
var dragging_skill_card_origin_position: Vector2

func _ready():
	init_game()
	start_game()
	
func _physics_process(delta):
	if Input.is_action_just_pressed("left_click"):
		var colliders = Util.get_collider_of_mouse_position(self)
		for collision in colliders:
			var collide_node = collision.collider.get_parent()
			if collide_node is Card:
				if current_player.cards.card_nodes.has(collide_node):
					selected_play_card = collide_node
					selected_play_card_origin_global_position = selected_play_card.global_position
					selected_play_card_offset = get_global_mouse_position() - selected_play_card.global_position
					break
				if selected_cards.has(collide_node):
					drag_selected_cards = true
					selected_cards_origin_positions = selected_cards.map(func (card): return card.global_position) as Array[Vector2]
					click_start_mouse_positon = get_global_mouse_position()
					break
			if collide_node is SkillCard:
				if collide_node.is_charged and current_player.skill_cards.has(collide_node):
					dragging_skill_card = collide_node
					dragging_skill_card_origin_position = dragging_skill_card.global_position
					click_start_mouse_positon = get_global_mouse_position()
	if Input.is_action_pressed("left_click"):
		if selected_play_card:
			selected_play_card.global_position = get_global_mouse_position() - selected_play_card_offset
		if drag_selected_cards:
			for index in range(selected_cards.size()):
				selected_cards[index].global_position = get_global_mouse_position() - click_start_mouse_positon + selected_cards_origin_positions[index]
		if dragging_skill_card:
			dragging_skill_card.global_position = get_global_mouse_position() - click_start_mouse_positon + dragging_skill_card_origin_position
	if Input.is_action_just_released("left_click"):
		if selected_play_card:
			if selected_play_card.get_overlapping_areas().has(play_area):
				play_card(selected_play_card.card_data)
			else:
				var tween = get_tree().create_tween()
				tween.tween_property(selected_play_card, 'global_position', selected_play_card_origin_global_position, 0.1).set_ease(Tween.EASE_OUT)
			selected_play_card = null
		if drag_selected_cards:
			var colliders = Util.get_collider_of_mouse_position(self)
			for collision in colliders:
				var collide_node = collision.collider.get_parent()
				if collide_node is SkillCard:
					var selected_card_datas: Array[CardData] = []
					selected_card_datas.assign(selected_cards.map(func (card): return card.card_data))
					var is_match = collide_node.try_charge_skill(selected_card_datas)
					if is_match:
						play_area.cards.remove_cards(selected_card_datas)
						selected_cards = []
			drag_selected_cards = false
		if dragging_skill_card:
			var colliders = Util.get_collider_of_mouse_position(self)
			for collision in colliders:
				var collide_node = collision.collider.get_parent()
				if collide_node is Player and collide_node != current_player:
					dragging_skill_card.apply_skill(collide_node)
					break
			var tween = get_tree().create_tween()
			tween.tween_property(dragging_skill_card, 'global_position', dragging_skill_card_origin_position, 0.1).set_ease(Tween.EASE_OUT)
			dragging_skill_card = null
	

func init_game():
	load_players()
	read_all_cards()
	init_draw_pile()

func load_players():
	var player1 = packed_player.instantiate()
	var player2 = packed_player.instantiate()
	add_child(player1)
	add_child(player2)
	players = [
		player1,
		player2
	]
	$Player1RemoteTransform2D.remote_path = player1.get_path()
	$Player2RemoteTransform2D.remote_path = player2.get_path()
	await player1.ready
	await player2.ready

func start_game():
	deal_initial_hand_cards()
	change_current_player(players[0])
	start_turn()

func deal_initial_hand_cards():
	for i in range(3):
		for player in players:
			draw_card(player)

func init_draw_pile():
	draw_pile = all_cards.duplicate()
	draw_pile.shuffle()

func suffle_deck():
	draw_pile.shuffle()

func read_all_cards():
	var directory_path = "res://cards"
	var dir_access = DirAccess.open(directory_path)
	dir_access.list_dir_begin()
	var file_name = dir_access.get_next()
	while file_name != "":
		if file_name == "." or file_name == "..":
			continue
		if dir_access.current_is_dir():
			var card_resource_path = directory_path + '/' + file_name + '/' + file_name + '.tres'
			if FileAccess.file_exists(card_resource_path):
				all_cards.append(load(card_resource_path))
		file_name = dir_access.get_next()
	dir_access.list_dir_end()

func draw_card(player: Player):
	if draw_pile.size() == 0:
		draw_pile = all_cards.duplicate()
		draw_pile.shuffle()
	var card = draw_pile.pop_back()
	player.draw_card(card)
	
func play_card(card_data: CardData):
	current_player.play_card(card_data)
	play_area.cards.append(card_data)
	
func player_request_end_turn(player: Player)->bool:
	end_turn()
	return true

func start_turn():
	draw_card(current_player)

func end_turn():
	change_current_player(players[(players.find(current_player) + 1) % players.size()])
	start_turn()
	
func change_current_player(p_player: Player):
	if current_player:
		current_player.end_turn()
	current_player = p_player
	current_player.start_turn()


func _on_end_turn_button_button_up():
	end_turn()


func _on_selection_area_selection_end(areas: Array[Area2D]):
	var new_selected_cards: Array[Card] = []
	for area in areas:
		var area_parent = area.get_parent()
		if area_parent is Card and play_area.cards.card_nodes.has(area_parent):
			new_selected_cards.push_back(area_parent)
	selected_cards = new_selected_cards
