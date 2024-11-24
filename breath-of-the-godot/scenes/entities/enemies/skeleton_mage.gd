extends CharacterBody3D


@export var move_speed := 4.0
@export var hit_range := 13.0
@onready var model = $SkeletonMageModel

var target: Node3D = null

func _physics_process(delta: float) -> void:
  handle_aggro(delta)

  move_and_slide()

func _on_area_3d_body_entered(body: Node3D) -> void:
  if body.is_in_group("Player"):
    target = body

func handle_aggro(_delta: float) -> void:
  if target and not target_in_cast_range():
    var direction = (target.global_transform.origin - global_transform.origin).normalized()
    self.velocity = Vector3(direction.x, 0, direction.z) * move_speed
    model.look_at(target.global_transform.origin)
    model.rotate_y(deg_to_rad(180))
    model.set_move_state('Walking_A')
  else:
    self.velocity = Vector3.ZERO
    model.set_move_state('Idle')
  
func target_in_cast_range() -> bool:
  return target and (self.position - target.position).length() <= hit_range

func _on_attack_timer_timeout() -> void:
  if target and target_in_cast_range():
    model.attack()