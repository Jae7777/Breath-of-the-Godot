extends Node

@export var stamina_bar: ProgressBar
@export var max_stamina := 50
@export var curr_stamina := 50

func _ready():
  stamina_bar.max_value = max_stamina
  stamina_bar.value = curr_stamina

func _process(_delta):
  stamina_bar.value = curr_stamina
