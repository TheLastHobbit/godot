extends Control

@onready var control = $Control2
@onready var color_rect = $CanvasLayer/ColorRect
@onready var main = $Main
var cur_player = 0

func _ready() -> void:
	# 添加按钮点击信号连接，并传递按钮索引
	control.button1.pressed.connect(_on_start_pressed.bind(1))
	control.button2.pressed.connect(_on_start_pressed.bind(2))
	control.button3.pressed.connect(_on_start_pressed.bind(3))
	control.button4.pressed.connect(_on_start_pressed.bind(4))

func _on_start_pressed(button_index: int) -> void:
	start_game(button_index)

func start_game(button_index: int):
	control.hide()
	main.show()
	Game.on_game_start.emit(button_index)  # 发出带参数的信号
	print("Button pressed:", button_index)
