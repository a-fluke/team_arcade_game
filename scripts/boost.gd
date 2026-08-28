extends Node2D

var dist_travelled : float = 0.0
var max_distance := 50.0
var velocity := 100
var parent

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if dist_travelled >= max_distance:
		self.queue_free()
	dist_travelled += velocity*delta
	position.y += velocity*delta



func _on_body_entered(body: Node2D) -> void:
	if body != parent:
		self.queue_free()
