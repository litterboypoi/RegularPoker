class_name PatternSuitUnit
extends PatternBaseUnit

@export var suit: CardData.SUIT

func is_match(card_data: CardData)->bool:
	return card_data.suit == suit
