class_name Item extends SpriteTile

@export var amount := 1

func _interact() -> void:
  queue_free()
