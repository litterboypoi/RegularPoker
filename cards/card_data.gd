# CardData 与 Card一一对应，如果有技能效果要造出一张一模一样的卡那要浅拷贝一份CardData数据
class_name CardData
extends Resource

enum SUIT {
	SPADE,
	HEART,
	CLUB,
	DIAMOND,
}

@export var rank: int
@export var suit: SUIT
@export var appreance: Resource
@export var special_appreance: PackedScene
