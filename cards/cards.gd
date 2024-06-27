class_name Cards
extends Node2D

var card_datas: Array[CardData] = []
var rendered_cards: Array[CardData] = []
var card_nodes: Array[Card] = []

func set_cards(p_cards: Array[CardData]):
	card_datas = p_cards
	render_cards()

func append(p_card: CardData):
	card_datas.append(p_card)
	render_cards()

func remove(p_card: CardData):
	card_datas.erase(p_card)
	render_cards()

func remove_cards(p_cards: Array[CardData]):
	for card in p_cards:
		card_datas.erase(card)
	render_cards()
	
func clear():
	card_datas = []
	render_cards()

# 类似react的渲染机制，由data控制视图
func render_cards():
	# 判断是否需要重新渲染
	if !should_rerendered_cards():
		return
	var new_card_nodes: Array[Card] = []
	# 移除旧节点
	for old_node in card_nodes:
		remove_child(old_node)
	# 渲染新节点
	for card in card_datas:
		var card_node = Spawner.spawn_card_node(card)
		new_card_nodes.append(card_node)
		add_child(card_node)
	card_nodes = new_card_nodes
	# 浅拷贝card_datas作为旧数据
	rendered_cards = card_datas.duplicate()
	layout_cards()
	

func should_rerendered_cards() -> bool:
	if card_datas.size() != rendered_cards.size():
		return true
	for i in range(card_datas.size()):
		if card_datas[i] != rendered_cards[i]:
			return true
	return false

func layout_cards():
	var offset = card_nodes.size() * 50 / 2
	for i in range(card_nodes.size()):
		card_nodes[i].position.x = i * 50 - offset
