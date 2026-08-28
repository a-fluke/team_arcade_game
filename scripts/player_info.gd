extends Node
class_name Player_Info

enum Status {
	SELECTOR,
	ALIVE,
	DEAD
}

var team : String 
var status
var player_id : int
var color


func _init() -> void:
	team = 'neutral'
