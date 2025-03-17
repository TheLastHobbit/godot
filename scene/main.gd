extends Node2D

const _player1 = preload("res://scene/player/character_body_2d.tscn")
const _player2 = preload("res://scene/player/panda.tscn")
@onready var canvas_layer =$CanvasLayer
@onready var map_land = $Land
@onready var color_rect = get_parent().color_rect  # 提前缓存

func _ready() -> void:
	Game.map = self
	Game.on_game_start.connect(on_game_start)

func on_game_start(cur_player:int):
	LevelManager.new_level()
	canvas_layer.show()
	print("cur_player:")
	print(cur_player)
	var temp;
	if cur_player==1:
		temp = _player1.instantiate()
	elif cur_player==2:
		temp = _player2.instantiate()
	var instance =temp;  
	print("player:")
	print(instance)
	
	add_child(instance)
