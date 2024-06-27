class_name PatternRankUnit
extends PatternBaseUnit

@export var rank: int

func is_match(card_data: CardData)->bool:
	return card_data.rank == rank
