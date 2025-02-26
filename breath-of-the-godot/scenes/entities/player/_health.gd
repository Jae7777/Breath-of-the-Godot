extends Node

@export var hp_bar: ProgressBar
@export var max_hp: int = 100
@export var curr_hp: int = 100

func _ready():
  hp_bar.max_value = max_hp
  hp_bar.value = curr_hp

func _process(_delta):
  hp_bar.value = curr_hp

func hit(amount: int):
  curr_hp -= amount
  curr_hp = max(curr_hp, 0)
  hp_bar.value = curr_hp
