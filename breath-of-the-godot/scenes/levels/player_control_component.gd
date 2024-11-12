extends Node

# jump
@export var jump_height := 2.25
@export var jump_time_to_peak := 0.4
@export var jump_time_to_descent := 0.3

@onready var jump_velocity := ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity := ((2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak))
@onready var fall_gravity := ((2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent))

@export var player: CharacterBody3D
@export var camera: Node3D
@export var base_speed := 6.0
@export var run_speed := 10.0

var movement_input := Vector2.ZERO

func _physics_process(delta: float) -> void:
	if camera:
		handle_move(delta)
		handle_jump(delta)
		
		player.move_and_slide()

func handle_move(delta: float) -> void:
	movement_input = Input.get_vector('move_left', 'move_right', 'move_forward', 'move_backward').rotated(-camera.global_rotation.y).normalized()
	var velocity_2d = Vector2(player.velocity.x, player.velocity.z)
	if movement_input.length() > 0.0:
		var move_speed = run_speed if Input.is_action_pressed("run") else base_speed
		velocity_2d += movement_input * move_speed * delta
		velocity_2d = velocity_2d.limit_length(move_speed)
	else:
		velocity_2d = velocity_2d.move_toward(Vector2.ZERO, base_speed * delta * 4.0)
	player.velocity.x = velocity_2d.x
	player.velocity.z = velocity_2d.y

func handle_jump(delta: float) -> void:
	if player.is_on_floor() and Input.is_action_just_pressed('jump'):
		print("jump")
		player.velocity.y = -jump_velocity
	var gravity = jump_gravity if player.velocity.y > 0.0 else fall_gravity
	player.velocity.y -= gravity * delta