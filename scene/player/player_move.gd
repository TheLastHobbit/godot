extends "res://scene/player/basePlayer.gd"
class_name Human


func play_idle_animation() -> void:
	anim.play(_current_anim + "idle")

func play_move_animation() -> void:
	anim.play(_current_anim + "move")
