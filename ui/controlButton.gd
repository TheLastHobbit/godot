extends Control

@onready var anim = $VBoxContainer/AnimatedSprite2D
@onready var button1 = $VBoxContainer/Start
@onready var button2 = $VBoxContainer/Connect
@onready var button3 = $VBoxContainer/EXIT

var current_button: Button = null  # 当前焦点按钮
var next_button: Button = null     # 下一个焦点按钮

func _ready():
	# 初始化焦点
	button1.grab_focus()
	current_button = button1
	
	# 设置焦点切换
	button1.focus_next = button2.get_path()
	button2.focus_next = button3.get_path()
	button3.focus_next = button1.get_path()

	button1.focus_previous = button3.get_path()
	button2.focus_previous = button1.get_path()
	button3.focus_previous = button2.get_path()

	# 连接按钮的焦点信号
	button1.connect("focus_entered", Callable(self, "_on_button_focus_entered"))
	button2.connect("focus_entered", Callable(self, "_on_button_focus_entered"))
	button3.connect("focus_entered", Callable(self, "_on_button_focus_entered"))

	# 连接按钮的输入事件（用于检测方向键按下）
	button1.connect("gui_input", Callable(self, "_on_button_gui_input"))
	button2.connect("gui_input", Callable(self, "_on_button_gui_input"))
	button3.connect("gui_input", Callable(self, "_on_button_gui_input"))

	# 连接鼠标悬停信号
	button1.connect("mouse_entered", Callable(self, "_on_button_mouse_entered").bind(button1))
	button2.connect("mouse_entered", Callable(self, "_on_button_mouse_entered").bind(button2))
	button3.connect("mouse_entered", Callable(self, "_on_button_mouse_entered").bind(button3))

func _on_button_focus_entered():
	# 当按钮获得焦点时，更新当前焦点按钮
	current_button = get_viewport().gui_get_focus_owner()

func _on_button_gui_input(event: InputEvent):
	if event is InputEventKey:
		# 检测方向键按下
		if event.pressed:
			var focus_owner = get_viewport().gui_get_focus_owner()
			if focus_owner:
				if event.keycode == KEY_DOWN:
					next_button = get_node(focus_owner.focus_next)
				elif event.keycode == KEY_UP:
					next_button = get_node(focus_owner.focus_previous)
			
				if next_button:
					# 在下一个焦点按钮的位置播放 press 动画
					anim.position = next_button.position + next_button.size / 2
					anim.play("press")
					
					# 连接动画完成信号
					anim.animation_finished.connect(Callable(self, "_on_animation_finished"), CONNECT_ONE_SHOT)

func _on_animation_finished():
	# 动画播放完成后，将焦点切换到下一个按钮
	if next_button:
		next_button.grab_focus()

func _on_button_mouse_entered(button: Button):
	# 当鼠标进入按钮时，播放 press 动画
	anim.position = button.position + button.size / 2
	anim.play("press")
	
	# 如果按钮不是当前焦点按钮，切换焦点
	if button != current_button:
		button.grab_focus()
