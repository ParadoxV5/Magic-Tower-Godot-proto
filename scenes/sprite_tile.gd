class_name SpriteTile extends Area2D

@export var penetrable: bool = false;

## This is a virtual method.
func _interact() -> void:
  print("interacting with:", self)
