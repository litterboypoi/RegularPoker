class_name PatternUnit
extends Resource

enum QUANTIFIER {
	ONE,
	OPTIONAL, # ?
	ANY, # *
	NOT_ZERO # +
}

@export var pattern_base_unit: PatternBaseUnit
@export var quantifier: QUANTIFIER = QUANTIFIER.ONE
