class_name Player_Input

extends Resource

const stick_thresh = 0.5

var device_id: int
var left_stick: Vector2 = Vector2.ZERO

var left_current = false
var left_previous = false
var right_current = false
var right_previous = false

var a_current : bool = false
var a_previous : bool = false

var b_current : bool = false
var b_previous : bool = false


func a_just_pressed():
	return a_current and !a_previous

func a_pressed():
	return a_current

func a_just_released():
	return !a_current and b_previous

func b_just_pressed():
	return b_current and !b_previous

func b_pressed():
	return b_current

func b_just_released():
	return !b_current and b_previous

func left_just_pressed():
	return left_current and !left_previous

func right_just_pressed():
	return right_current and !right_previous
