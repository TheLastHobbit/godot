extends "res://scene/weapon/base_weapon.gd"
class_name PandaWeapon

const _curr_bullet = preload("res://scene/bullet/pandaBullet.tscn")

@onready var anim = $"../../AnimatedSprite2D"

func _ready() -> void:
	weapon_rof = 1.5
	fire_particles=null
	#fire_particles.lifetime = weapon_rof - 0.01
	_pre_bullet = _curr_bullet
	current_bullet_count = bullet_max
	PlayerManager.on_weapon_changed.emit(self)
	PlayerManager.on_bullet_count_changed.emit(current_bullet_count, bullet_max)

func shoot():
	PlayerManager.on_panda_shoot_anim.emit()
	await get_tree().create_timer(0.3).timeout

	var instance = _pre_bullet.instantiate()
	instance.global_position = bullet_point.global_position

	# 限制子弹方向为水平方向
	var mouse_direction = global_position.direction_to(get_global_mouse_position())
	var horizontal_direction = Vector2(mouse_direction.x, 0).normalized()  # 仅保留 X 轴方向
	instance.dir = horizontal_direction

	instance.current_weapon = self
	get_tree().root.add_child(instance)
	current_bullet_count -= 1
	PlayerManager.on_bullet_count_changed.emit(current_bullet_count, bullet_max)

	if current_bullet_count <= 0:  # 自动换弹
		reload()
	weapon_anim()

func weapon_anim():
	#fire_particles.restart()
	var tween = create_tween().set_ease(Tween.EASE_IN)
	tween.tween_property(sprite, "scale:x", 0.2, weapon_rof / 2)
	tween.tween_property(sprite, "scale:x", 0.3, weapon_rof / 2)
	audio2d.play()
	Game.camera_offset(Vector2(-1.5, 2), weapon_rof)

func reload():
	PlayerManager.on_weapon_reload.emit()
	await get_tree().create_timer(2).timeout  # 模拟换弹需要2秒
	current_bullet_count = bullet_max
	PlayerManager.on_bullet_count_changed.emit(current_bullet_count, bullet_max)

func _process(delta: float) -> void:
	current_rof_tick += delta
	if Input.is_action_pressed("fire") and current_rof_tick >= weapon_rof && current_bullet_count > 0:
		shoot()
		current_rof_tick = 0
