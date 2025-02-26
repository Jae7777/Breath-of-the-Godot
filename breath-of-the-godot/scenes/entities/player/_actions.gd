extends Node

@export var model: Node3D
@export var movement: Node
@export var primary_action_timer: Timer
@export var primary_action_cooldown_bar: ProgressBar
@export var primary_action_attack_speed = 0.8

var is_defending = false
var is_attacking = false
var primary_action_weapon
var secondary_action_weapon

func _ready() -> void:
  primary_action_timer.wait_time = primary_action_attack_speed
  primary_action_cooldown_bar.value = primary_action_cooldown_bar.max_value

func _physics_process(_delta: float) -> void:
  handle_primary_action()
  handle_secondary_action()
  handle_switch_action()
  primary_action_cooldown_bar.value = primary_action_cooldown_bar.max_value - primary_action_timer.time_left

func handle_primary_action() -> void:
  if Input.is_action_just_pressed('primary_action'):
    is_attacking = true
    if primary_action_timer.time_left == 0:
      model.primary_action() 
      primary_action_timer.start()
      movement.stop_movement(0.3, 0.3)

func handle_secondary_action() -> void:
  is_defending = Input.is_action_pressed('secondary_action')
  model.defend(not is_defending)

func handle_switch_action() -> void:
  if Input.is_action_just_pressed('switch_weapon'):
    model.switch_weapon(true)

func hit():
  model.hit()
  movement.stop_movement(0.3, 0.8)

func _on_primary_action_timer_timeout() -> void:
  is_attacking = false
