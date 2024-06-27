class_name Draggable
extends Area2D

enum DRAGGING_ACTION {
	NONE,
	PLAY_CARD,
	PLAY_SKILL
}

signal drag_start(dragging_action: String)
signal drag_doing(dragging_action: String)
signal drag_end(dragging_action: String)
signal dragging_action_finish(dragging_action: String)

var dragging_action: DRAGGING_ACTION = DRAGGING_ACTION.NONE

var parent: Node2D
var is_active = false
var origin_global_position: Vector2
var offset: Vector2
var interactive_areas: Array[Node2D] = []

func _ready():
	parent = get_parent()

func _process(delta):
	if is_active:
		if Input.is_action_just_pressed('left_click'):
			origin_global_position = parent.global_position
			offset = get_global_mouse_position() - global_position
			Global.is_dragging = true
			emit_signal("drag_start", dragging_action)
		if Input.is_action_pressed("left_click"):
			parent.global_position = get_global_mouse_position() - offset
			emit_signal("drag_end", dragging_action)
		elif Input.is_action_just_released("left_click"):
			Global.is_dragging = false
			if interactive_areas.size() != 0:
				interactive_areas[0].interact_with_draggable(self)
				emit_signal("dragging_action_finish", dragging_action)
			else:
				var tween = get_tree().create_tween()
				tween.tween_property(parent, 'global_position', origin_global_position, 0.1).set_ease(Tween.EASE_OUT)
			emit_signal("drag_end", dragging_action)

func _on_mouse_entered():
	if !Global.is_dragging and dragging_action != DRAGGING_ACTION.NONE:
		is_active = true
		parent.scale = Vector2(1.05, 1.05)

func _on_mouse_exited():
	if !Global.is_dragging:
		is_active = false
		parent.scale = Vector2(1, 1)

func _on_area_entered(area):
	if area.has_method('interact_with_draggable') and area.has_method('can_interact_with') and area.can_interact_with(dragging_action):
		interactive_areas.append(area)

func _on_area_exited(area):
	if area.has_method('interact_with_draggable') and area.has_method('can_interact_with') and area.can_interact_with(dragging_action):
		interactive_areas.erase(area)
