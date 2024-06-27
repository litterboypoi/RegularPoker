class_name SelectionArea
extends Area2D

signal selection_end(areas: Array[Area2D])

@export var select_start_point: Vector2 = Vector2.ZERO
@export var select_end_point: Vector2 = Vector2.ZERO

@export var react_size: Vector2 = Vector2.ZERO

var is_dragging = false

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _input(event):
	if event is InputEventMouseButton:
		if event.is_action_pressed("shift_left_click"):
			select_start_point = get_global_mouse_position()
			select_end_point = select_start_point
			is_dragging = true
		elif event.is_action_released("shift_left_click") and is_dragging:
			is_dragging = false
			collision_shape.shape = null
			queue_redraw()
			emit_signal("selection_end", get_overlapping_areas())
	elif event is InputEventMouseMotion and is_dragging:
		select_end_point = get_global_mouse_position()
		update_selection_box()

func update_selection_box():
	react_size = select_end_point - select_start_point
	var rect_shape = RectangleShape2D.new()
	rect_shape.size = Vector2(abs(select_end_point.x - select_start_point.x), abs(select_end_point.y - select_start_point.y))
	collision_shape.shape = rect_shape
	collision_shape.position = react_size / 2
	global_position = select_start_point
	queue_redraw()
	
func _draw():
	if is_dragging:
		draw_rect(Rect2(Vector2.ZERO, react_size), Color(0,0,1,0.3))
