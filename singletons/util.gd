extends Node

func get_collider_of_mouse_position(node: Node2D) ->  Array[Dictionary]:
	var space_state = node.get_world_2d().direct_space_state
	var mouse_position = node.get_global_mouse_position()
	var query = PhysicsPointQueryParameters2D.new()
	query.position = mouse_position
	query.collide_with_areas = true
	query.collide_with_bodies = false
	var result = space_state.intersect_point(query)
	return result
