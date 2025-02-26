extends GridContainer

@export var inventory: Node
@onready var slot_scene = preload('res://scenes/entities/player/inventory_slot.tscn')

func _ready() -> void:
  for i in range(inventory.num_slots):
    add_child(slot_scene.instantiate())


func _process(delta: float) -> void:
  pass
