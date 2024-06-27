extends Node

var packed_card = preload("res://cards/card.tscn")

func spawn_card_node(card_data: CardData) -> Card:
	var card_node = packed_card.instantiate() as Card
	card_node.card_data = card_data
	return card_node
	
