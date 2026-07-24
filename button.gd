extends Node2D
class_name Custom_Button


signal button_pressed

var nearby_players : Array[Player_Cursor]

func _on_area_2d_area_entered(area: Area2D) -> void:
	var body = area.get_parent()
	if body is Player_Cursor and body not in nearby_players:
		nearby_players.append(body)
		body.interact.connect(_on_player_interact)




func _on_area_2d_area_exited(area: Node2D) -> void:
	var body = area.get_parent()
	if body in nearby_players:
		nearby_players.erase(body)
		body.interact.disconnect(_on_player_interact)


func _on_player_interact():
	button_pressed.emit()
	print("pressed")
