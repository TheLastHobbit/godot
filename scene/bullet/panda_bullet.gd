extends "res://scene/bullet/bullet.gd"
class_name PandaBullet

@onready var bullet_sprite = $AnimatedSprite2D

func _ready() -> void:
	#_pre_hit_effect =null;
	speed = 100
	bullet_sprite.play("fly")
	
	# 限制子弹方向为水平方向
	var mouse_direction = global_position.direction_to(get_global_mouse_position())
	dir = Vector2(mouse_direction.x, 0).normalized()  # 仅保留 X 轴方向

	# 让子弹节点朝向水平方向
	rotation = dir.angle()

func _physics_process(delta: float) -> void:
	# 根据子弹的方向 `dir`、速度 `speed` 和时间间隔 `delta` 更新子弹的全局位置
	global_position += dir * delta * speed
	_tick += delta

	# 如果子弹存在时间超过 3 秒，销毁子弹
	if Engine.get_physics_frames() % 20 == 0:
		if _tick >= 3:
			queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	print(body)
	if body is BaseEnemy:
		Game.damage(Game.player, body)
		set_physics_process(false)
		var ins = _pre_hit_effect.instantiate()
		ins.global_position = global_position
		Game.map.add_child(ins)
		queue_free()  # 子弹碰撞敌人后就消失
