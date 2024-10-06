class_name Item extends SpriteTile

@export var amount := 1
## This is a virtual method.
func explain() -> String: return str(self)

func _interact() -> void:
  queue_free()
