extends ProgressBar

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
  self.visible = not self.value == self.max_value
