# 定义一个继承自 `Node2D` 的类 `BaseBullet`，用于表示子弹对象
extends Node2D
class_name BaseBullet

var _pre_hit_effect = preload("res://scene/Hit_Effect.tscn")
# 使用 `@export` 关键字将 `speed` 变量暴露在编辑器中，允许在编辑器中调整子弹的速度
@export var speed = 50

# 使用 `@export` 关键字将 `dir` 变量暴露在编辑器中，表示子弹的移动方向，默认值为 `Vector2.ZERO`（即不移动）
@export var dir = Vector2.ZERO

var current_weapon:BaseWeapon # 属于某个武器
var _tick = 0 

# `_ready` 函数在节点首次进入场景树时调用
func _ready() -> void:
	# 让子弹节点朝向全局鼠标位置，即子弹生成时会朝向鼠标所在的方向
	look_at(get_global_mouse_position())

# `_physics_process` 函数在物理帧更新时调用，`delta` 是自上一物理帧以来的时间间隔（以秒为单位）
func _physics_process(delta: float) -> void:
	# 根据子弹的方向 `dir`、速度 `speed` 和时间间隔 `delta` 更新子弹的全局位置
	# 这样子弹就会以指定的速度和方向移动
	global_position += dir * delta * speed
	_tick += delta
	if Engine.get_physics_frames() % 20 :
		if _tick >= 3:
			queue_free()
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	print(body);
	if body is BaseEnemy:
		Game.damage(Game.player,body)
		set_physics_process(false)
		var ins = _pre_hit_effect.instantiate()
		ins.global_position = global_position
		Game.map.add_child(ins)
		queue_free()#子弹碰撞敌人后就消失
