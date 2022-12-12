extends KinematicBody2D

const ACCELERATION = 500
const MAX_SPEED = 100
const FRICTION = 0.5
const GRAVITY = 200
const JUMP_FORCE = 128
const AIR_RESISTANCE = 0.02

var motion = Vector2.ZERO

onready var playerImage = get_node("Player")

func _physics_process(delta):
	var x_input = Input.get_action_strength("PlayerRight") - Input.get_action_strength("PlayerLeft")
	
	if x_input != 0:
		motion.x += x_input * ACCELERATION * delta
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
		playerImage.flip_h = x_input < 0
		
	motion = move_and_slide(motion, Vector2.UP)
	
	motion.y += GRAVITY * delta
	if is_on_floor():
		if x_input == 0:
			motion.x = lerp(motion.x, 0, FRICTION)
		if Input.is_action_just_pressed("PlayerJump"):
			motion.y = -JUMP_FORCE
	else:
		if Input.is_action_just_released("PlayerJump") and motion.y < -JUMP_FORCE/2:
			motion.y = -JUMP_FORCE / 2
		if x_input == 0:
			motion.x = lerp(motion.x, 0, AIR_RESISTANCE)
