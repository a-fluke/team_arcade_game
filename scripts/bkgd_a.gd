extends Node2D

func _ready() -> void:
	$bkgd.z_index = World.BACKGROUND_Z
	$frgd.z_index = World.FOREGROUND_Z
