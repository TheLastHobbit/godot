extends CharacterBody2D
class_name Player

@onready var anim = $body/AnimatedSprite2D
@onready var body = $body
@onready var weapon_node = $body/weaponNode
@onready var camera = $Camera2D

const SPEED = 100.0
var _current_anim = 'down_'

func _ready() -> void:
	Game.player = self
	PlayerManager.on_player_death.connect(on_player_death)

func on_player_death() -> void:
	weapon_node.hide()
	anim.play("death")

func _physics_process(delta: float) -> void:
	if PlayerManager.isDeath():
		return
		
	var direction = Vector2.ZERO
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")
	velocity = direction.normalized() * SPEED
	
	changeAnim()
	move_and_slide()

func changeAnim() -> void:
	if velocity == Vector2.ZERO:
		play_idle_animation()
	else:
		_current_anim = get_movement_dir()
		play_move_animation()
	update_weapon_direction()

# 这些方法将由子类实现
func play_idle_animation() -> void:
	pass

func play_move_animation() -> void:
	pass

func get_movement_dir() -> String:
	weapon_node.z_index = 1
	if velocity == Vector2.ZERO:
		return 'lr_'
	
	var angle = velocity.angle()
	var degree = rad_to_deg(angle)
	
	if 45 <= degree and degree < 135:
		return 'down_'
	elif -135 <= degree and degree < -45:
		weapon_node.z_index = 0
		return 'up_'
	return 'lr_'

func update_weapon_direction() -> void:
	var _mouse_position = get_global_mouse_position()
	weapon_node.look_at(_mouse_position)
	
	if _mouse_position.x > position.x and body.scale.x != 1:
		body.scale.x = 1
	elif _mouse_position.x < position.x and body.scale.x != -1:
		body.scale.x = -1
