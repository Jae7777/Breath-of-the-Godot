extends CharacterBody3D


@export var move_speed := 160.0
@onready var model = $SkeletonMageModel

var target: Node3D = null

func _physics_process(delta: float) -> void:
  handle_aggro(delta)
  if self.velocity.length() > 0:
    # model.animation = "Walk"
    pass
  else:
    # model.animation = "Idle"
    pass
  move_and_slide()

func _on_area_3d_body_entered(body: Node3D) -> void:
  if body.is_in_group("Player"):
    target = body

func handle_aggro(delta: float) -> void:
  if target:
    var direction = (target.global_transform.origin - global_transform.origin).normalized()
    self.velocity = Vector3(direction.x, 0, direction.z) * move_speed * delta