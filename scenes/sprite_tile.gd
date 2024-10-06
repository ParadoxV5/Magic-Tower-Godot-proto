class_name SpriteTile extends Area2D

@export var penetrable: bool = false;

func get_texture() -> Texture2D: return $Sprite2D.texture


## This is a virtual method.
func _interact() -> void:
  prints("interacting with:", self)
