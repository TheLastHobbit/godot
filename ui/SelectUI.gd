extends Control

@onready var rect = $NinePatchRect
@onready var button1 = $TextureButton
@onready var button2 = $TextureButton2
@onready var button3 = $TextureButton3
@onready var button4 = $TextureButton4

var current_button: TextureButton = null
var next_button: TextureButton = null
var all_buttons: Array = []




func _ready():
	button1.grab_focus()
	current_button = button1
	
	all_buttons = [button1, button2, button3, button4]
	
	button1.focus_next = button2.get_path()
	button2.focus_next = button3.get_path()
	button3.focus_next = button1.get_path()

	button1.focus_previous = button3.get_path()
	button2.focus_previous = button1.get_path()
	button3.focus_previous = button2.get_path()
	
	# 连接鼠标悬停和焦点信号
	button1.mouse_entered.connect(_on_button_mouse_entered.bind(button1))
	button2.mouse_entered.connect(_on_button_mouse_entered.bind(button2))
	button3.mouse_entered.connect(_on_button_mouse_entered.bind(button3))
	button4.mouse_entered.connect(_on_button_mouse_entered.bind(button4))
	
	button1.focus_entered.connect(_on_button_focus_entered.bind(button1))
	button2.focus_entered.connect(_on_button_focus_entered.bind(button2))
	button3.focus_entered.connect(_on_button_focus_entered.bind(button3))
	button4.focus_entered.connect(_on_button_focus_entered.bind(button4))
	
	# 添加按钮点击信号连接
	#button1.pressed.connect(_on_start_pressed)  # 假设 button1 是开始游戏按钮
	
	rect.pivot_offset = rect.size / 2
	update_buttons_brightness(button1)
	update_rect_position(button1)
	button1.grab_focus()
	current_button = button1
	
	all_buttons = [button1, button2, button3, button4]
	
	button1.focus_next = button2.get_path()
	button2.focus_next = button3.get_path()
	button3.focus_next = button1.get_path()

	button1.focus_previous = button3.get_path()
	button2.focus_previous = button1.get_path()
	button3.focus_previous = button2.get_path()
	
	button1.mouse_entered.connect(_on_button_mouse_entered.bind(button1))
	button2.mouse_entered.connect(_on_button_mouse_entered.bind(button2))
	button3.mouse_entered.connect(_on_button_mouse_entered.bind(button3))
	button4.mouse_entered.connect(_on_button_mouse_entered.bind(button4))
	
	button1.focus_entered.connect(_on_button_focus_entered.bind(button1))
	button2.focus_entered.connect(_on_button_focus_entered.bind(button2))
	button3.focus_entered.connect(_on_button_focus_entered.bind(button3))
	button4.focus_entered.connect(_on_button_focus_entered.bind(button4))
	
	rect.pivot_offset = rect.size / 2
	update_buttons_brightness(button1)
	update_rect_position(button1)

func _on_button_mouse_entered(button: TextureButton):
	button.grab_focus()
	current_button = button

func _on_button_focus_entered(button: TextureButton):
	current_button = button
	update_rect_position(button)
	update_buttons_brightness(button)

func update_buttons_brightness(focused_button: TextureButton):
	for button in all_buttons:
		var tween = create_tween()
		if button == focused_button:
			tween.tween_property(button, "modulate", Color(1, 1, 1, 1), 0.1)
		else:
			tween.tween_property(button, "modulate", Color(0.5, 0.5, 0.5, 1), 0.1)

func update_rect_position(button: TextureButton):
	var tween = create_tween()
	tween.set_parallel(true)
	
	rect.size = button.size
	
	# 快速缩小
	tween.tween_property(rect, "scale", Vector2(0.95, 0.95), 0.05)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN)
	
	# 移动到新位置
	tween.tween_property(rect, "position", button.position, 0.1)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)
	
	# 弹性放大
	tween.tween_property(rect, "scale", Vector2(1.1, 1.1), 0.1)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)\
		.set_delay(0.05)
	
	# 恢复正常大小
	tween.tween_property(rect, "scale", Vector2(1.0, 1.0), 0.05)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)\
		.set_delay(0.15)

func _input(event: InputEvent):
	if event is InputEventKey:
		if event.pressed:
			if event.keycode == KEY_LEFT or event.keycode == KEY_RIGHT:
				await get_tree().process_frame
				if get_viewport().gui_get_focus_owner() is TextureButton:
					var focused = get_viewport().gui_get_focus_owner()
					update_rect_position(focused)
					update_buttons_brightness(focused)
