class_name PatternSuitRankUnit
extends PatternBaseUnit

@export var suit: CardData.SUIT
@export var rank: int = 0

func is_match(card_data: CardData)->bool:
	return card_data.rank == rank and card_data.suit == suit
