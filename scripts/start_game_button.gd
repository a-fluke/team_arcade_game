extends TextureButton


func _ready() -> void:
	release_focus()
	disabled = true

func _process(delta: float) -> void:
	if get_tree().current_scene.get_node("Player_Container").players_ready():
		enable()
		disabled = false
	#elif disabled:
		#pass
	else:
		disable()

func enable():
	disabled = false
	grab_focus()

func disable():
	disabled = true
	release_focus()
