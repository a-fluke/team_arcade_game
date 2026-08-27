extends Node2D

signal charge(team)

@export var team := "blue"

@export var ground_y := 12.0
@export var cable_height := 10.0

@onready var line: Line2D = $Line
@onready var outline: Line2D = $Outline

@onready var source: Node2D = get_node("../%s_source_point"%team)
@onready var cable_end: Node2D = $plug/cablePoint

const colors = [Color(0.282, 0.322, 0.384),Color(0.337, 0.31, 0.357)]

var charging

func _ready() -> void:
	$spool.global_position = source.global_position
	$plug.team = team
	$plug/Sprite2D.texture = load("res://assets/outlet/%s_plug.png"%team)
	if team == "red":
		scale.x = -1
		$plug/Sprite2D.flip_h = true
		$Line.default_color = colors[1]
	else:
		scale.x = 1
		$Line.default_color = colors[0]
	

func _process(_delta):
	update_cable()
	spool_animation()

func spool_animation():
	if team == "blue":
		if $plug.moving_left:
			$spool.play("unwind")
		elif $plug.moving_right:
			$spool.play("wind")
		else:
			$spool.pause()
	elif team == "red":
		if $plug.moving_right:
			$spool.play("unwind")
		elif $plug.moving_left:
			$spool.play("wind")
		else:
			$spool.pause()

func update_cable():
	var start := line.to_local(source.global_position)
	var end := line.to_local(cable_end.global_position)

	var points := PackedVector2Array()

	# How far apart are the endpoints?
	var distance := start.distance_to(end)

	# Cable drops from both ends and rests on the ground.
	points.append(start)
	points.append(
		Vector2(start.x, ground_y)
	)
	points.append(
		Vector2(end.x, ground_y)
	)
	points.append(end)

	line.points = points
	outline.points = points


func _on_plug_docked() -> void:
	charging = true
	$charge_affect.charge_progress = 0.0
	$chargeTimer.start()

func _on_plug_removed() -> void:
	charging = false
	$chargeTimer.stop()
	
func _on_charge_timer_timeout() -> void:
	charge.emit(team)
	$chargeTimer.start()
