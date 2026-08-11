extends Node

const MAX_PLAYERS = 6

const GRAVITY : float = 600.0
const PLAYER_COLORS : Array[Color] = [Color.DARK_BLUE, Color.DARK_RED, Color.ORANGE, Color.WEB_GREEN]

const FOREGROUND_Z      = 1000
const HELD_ITEM_Z       = 110
const PLAYER_Z          = 100
const DROPPED_ITEM_Z    = 90
const DOCK_FOREGROUND_Z = 80
const PLACED_ITEM_Z     = 70
const DOCK_BACKGROUND_Z = 60
const PLATFORM_Z        = 50
const BACKGROUND_Z      = -1000

var available_colors : = {
	'green':true,
	'yellow':true,
	'orange':true,
	'red':true,
	'magenta':true,
	'blue':true,
	'purple':true,
	'grey':true
}

var player_colors = [
	'green',
	'yellow',
	'orange',
	'red',
	'magenta',
	'blue',
	'purple',
	'grey',
]

var player_count = 0
