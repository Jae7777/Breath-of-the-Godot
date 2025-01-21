extends CharacterBody3D

@onready var camera = $Camera
@onready var model = $GodetteModel

# jump
@export var jump_height := 2.25
@export var jump_time_to_peak := 0.4
@export var jump_time_to_descent := 0.3

@onready var jump_velocity := ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity := ((2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak))
@onready var fall_gravity := ((2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent))

var jump_landed := true

# movement
@export var base_speed := 6.0
@export var run_speed := 10.0
@export var defend_speed := 2.0

var movement_input := Vector2.ZERO

var speed_modifier := 1.0

var defending := false:
	set(value):
		if not defending and value:
			model.defend(true)
		if defending and not value:
			model.defend(false)
		defending = value
var weapon_active := false

func _physics_process(delta: float) -> void:
	handle_move(delta)
	handle_jump(delta)
	handle_ability()
	if Input.is_action_just_pressed('ui_accept'):
		self.hit()
	
	self.move_and_slide()

func _get_move_speed() -> float:
	if defending:
		return defend_speed
	if Input.is_action_pressed("run"):
		return run_speed
	return base_speed

func handle_move(delta: float) -> void:
	movement_input = Input.get_vector('move_left', 'move_right', 'move_forward', 'move_backward').rotated(-camera.global_rotation.y).normalized()
	var velocity_2d = Vector2(self.velocity.x, self.velocity.z)
	if movement_input.length() > 0.0:
		var move_speed = self._get_move_speed()
		velocity_2d = movement_input * move_speed
		model.set_move_state("Running_B")
		var target_angle = -movement_input.angle() + PI/2
		model.rotation.y = rotate_toward(model.rotation.y, target_angle, 9.0 * delta)
	else:
		velocity_2d = velocity_2d.move_toward(Vector2.ZERO, base_speed * delta * 4.0)
		model.set_move_state("Idle")
	velocity_2d *= speed_modifier
	self.velocity.x = velocity_2d.x
	self.velocity.z = velocity_2d.y

func handle_jump(delta: float) -> void:
	if self.is_on_floor() and Input.is_action_just_pressed('jump'):
		jump_landed = false
		self.velocity.y = -jump_velocity
	if self.is_on_floor():
		jump_landed = true
	if not jump_landed:
		model.set_move_state("Jump_Idle")
		do_squash_and_stretch(1.2, 0.1, 0.18)
	var gravity = jump_gravity if self.velocity.y > 0.0 else fall_gravity
	self.velocity.y -= gravity * delta

func handle_ability() -> void:
	# actual attack
	if Input.is_action_just_pressed('ability'):
		if weapon_active:
			model.attack()
		else:
			model.cast_spell()
			self.stop_movement(0.3, 0.3)

	# defend
	defending = Input.is_action_pressed('defend')

	# weapon switch
	if Input.is_action_just_pressed('switch_weapon') and not model.attacking:
		weapon_active = not weapon_active
		model.switch_weapon(weapon_active)
		do_squash_and_stretch(1.2, 0.1, 0.18)

func stop_movement(start_duration: float, end_duration: float):
	var tween = create_tween()
	tween.tween_property(self, 'speed_modifier', 0.0, start_duration)
	tween.tween_property(self, 'speed_modifier', 1.0, end_duration)

func hit():
	model.hit()
	stop_movement(0.3, 0.8)

func do_squash_and_stretch(value: float, start_duration: float, end_duration: float):
	var tween = create_tween()
	tween.tween_property(model, 'squash_and_stretch', value, start_duration)
	tween.tween_property(model, 'squash_and_stretch', 1.0, end_duration).set_ease(Tween.EASE_OUT)