extends Node

@export var camera: Node3D
@export var model: Node3D
@export var character: CharacterBody3D
@export var action: Node

@onready var jump_velocity: float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity: float = ((2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak))
@onready var fall_gravity: float = ((2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent))

@export var jump_height: float = 2.25
@export var jump_time_to_peak := 0.4
@export var jump_time_to_descent := 0.3

@export var base_speed := 6.0
@export var run_speed := 10.0
@export var defend_speed := 2.0

var jump_landed := true
var movement_input := Vector2.ZERO
var speed_modifier := 1.0

var is_falling = false
var is_walking = false
var is_sprinting = false

func _physics_process(delta: float) -> void:
  is_sprinting = Input.is_action_pressed('sprint')
  handle_move(delta)
  handle_jump(delta)
  character.move_and_slide()

func _get_move_speed() -> float:
  if action.is_defending:
    return defend_speed
  if is_sprinting:
    return run_speed
  return base_speed

func handle_move(delta: float) -> void:
  movement_input = Input.get_vector('move_left', 'move_right', 'move_forward', 'move_backward').rotated(-camera.global_rotation.y).normalized()
  var velocity_2d = Vector2(character.velocity.x, character.velocity.z)
  if movement_input.length() > 0.0:
    var move_speed = _get_move_speed()
    velocity_2d = movement_input * move_speed
    model.set_move_state("Running_B")
    var target_angle = -movement_input.angle() + PI/2
    model.rotation.y = rotate_toward(model.rotation.y, target_angle, 9.0 * delta)
  else:
    velocity_2d = velocity_2d.move_toward(Vector2.ZERO, base_speed * delta * 4.0)
    model.set_move_state("Idle")
  velocity_2d *= speed_modifier
  character.velocity.x = velocity_2d.x
  character.velocity.z = velocity_2d.y

func handle_jump(delta: float) -> void:
  if character.is_on_floor and Input.is_action_just_pressed('jump'):
    jump_landed = false
    character.velocity.y = -jump_velocity
  if character.is_on_floor:
    jump_landed = true
  if not jump_landed:
    model.set_move_state("Jump_Idle")
  var gravity = jump_gravity if character.velocity.y > 0.0 else fall_gravity
  character.velocity.y -= gravity * delta

func stop_movement(start_duration: float, end_duration: float):
  var tween = create_tween()
  tween.tween_property(self, 'speed_modifier', 0.0, start_duration)
  tween.tween_property(self, 'speed_modifier', 1.0, end_duration)
