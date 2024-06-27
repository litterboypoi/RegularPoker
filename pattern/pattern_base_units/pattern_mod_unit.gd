class_name PatternModUnit
extends PatternBaseUnit

@export var remainder: int
@export var modulus: int

func is_match(card_data: CardData)->bool:
	return card_data.rank % modulus == remainder

