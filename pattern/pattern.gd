class_name Pattern
extends Resource

@export var pattern_unit_list: Array[PatternUnit]

func is_match(card_datas: Array[CardData]) -> bool:
	return _match_helper(card_datas, pattern_unit_list)

func _match_helper(card_datas: Array[CardData], p_pattern: Array[PatternUnit]) -> bool:
	if card_datas.size() == 0 and p_pattern.size() == 0:
		return true
	elif p_pattern.size() == 0:
		return false
	var first_pattern = p_pattern[0]
	var is_first_match = card_datas.size() > 0 and first_pattern.pattern_base_unit.is_match(card_datas[0])
	match first_pattern.quantifier:
		PatternUnit.QUANTIFIER.ONE:
			# asd : asf -> a == a and sd : sf
			return is_first_match and _match_helper(card_datas.slice(1), p_pattern.slice(1))
		PatternUnit.QUANTIFIER.OPTIONAL:
			# asd : a?sf -> a == a and sd : sf or asd : sf
			return (
				(is_first_match and _match_helper(card_datas.slice(1), p_pattern.slice(1)))
				 or _match_helper(card_datas, p_pattern.slice(1))
			)
		PatternUnit.QUANTIFIER.NOT_ZERO:
			# asd : a+sf -> a == a and sd : a*sf
			var new_first_pattern_unit = first_pattern.duplicate() as PatternUnit
			new_first_pattern_unit.quantifier = PatternUnit.QUANTIFIER.ANY
			var new_pattern = p_pattern.duplicate()
			new_pattern[0] = new_first_pattern_unit
			return (
				is_first_match and _match_helper(card_datas.slice(1), new_pattern)
			)
		PatternUnit.QUANTIFIER.ANY:
			# asd : a*sf -> asd : sf or a == a and sd : a*sf
			# aasd : a*sf -> (aasd : sf) or (a == a and asd : a*sf)
			return (
				_match_helper(card_datas, p_pattern.slice(1))
				or is_first_match and _match_helper(card_datas.slice(1), p_pattern)
			)
		_:
			return false
