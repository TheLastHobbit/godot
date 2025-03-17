extends "res://scene/player/basePlayer.gd"
class_name Panda

var isShoot = false

func _ready() -> void:
	super()
	PlayerManager.on_panda_shoot_anim.connect(on_shoot)

func on_shoot() -> void:
	isShoot = true

func changeAnim() -> void:
	if isShoot:
		anim.play("shoot")
		print(isShoot)
		
		# 手动指定延时时间（例如 0.5 秒）
		await get_tree().create_timer(0.5).timeout
		
		isShoot = false  # 重置 isShoot 状态
		return
	super.changeAnim()
	if isShoot:
		anim.play("shoot")
		print(isShoot)
		
		# 获取当前动画的长度
		var animation_length = anim.sprite_frames.get_animation_length(anim.animation)
		
		# 添加延时，等待动画播放完成
		await get_tree().create_timer(animation_length).timeout
		
		isShoot = false  # 重置 isShoot 状态
		return
	super.changeAnim()
	if isShoot:
		anim.play("shoot")
		print(isShoot)
		
		# 添加延时，等待动画播放完成
		await get_tree().create_timer(anim.current_animation_length).timeout
		
		isShoot = false  # 重置 isShoot 状态
		return
	super.changeAnim()

func play_idle_animation() -> void:
	anim.play(_current_anim + "idle")

func play_move_animation() -> void:
	anim.play("move")
