extends Node

@export var target: Node3D
@export var min_limit_x := -0.8
@export var max_limit_x := -0.2
@export var mouse_acceleration := 0.005

func _physics_process(_delta: float) -> void:
  self.global_transform.origin = target.global_transform.origin

func _input(event: InputEvent) -> void:
  if event is InputEventMouseMotion:
    rotate_from_vector(event.relative * mouse_acceleration)

func rotate_from_vector(v: Vector2) -> void:
  if v.length() == 0: return
  self.rotation.y -= v.x
  self.rotation.x = clamp(self.rotation.x - v.y, min_limit_x, max_limit_x)
