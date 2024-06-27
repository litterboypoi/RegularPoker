class_name DamageEffect
extends Effect

@export var damage: int = 0

func apply(target: Player):
	target.take_damage(damage)
