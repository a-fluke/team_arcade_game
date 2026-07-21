extends Node2D
class_name Dock

enum State {
	EMPTY,
	PARTIAL,
	FULL
}

var valid_nearby_items : Array[Carryable] = []
var docking_location : Vector2 = self.global_position
var state := State.EMPTY
var docked_item : Carryable

func accepts(item):
	return item is Carryable

func empty():
	state = State.EMPTY

func _dock(item : Carryable):
	state = State.FULL
