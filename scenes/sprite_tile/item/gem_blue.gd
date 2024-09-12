class_name GemBlue extends Item

func _interact() -> void:
  Player.instance.def += amount
  super()
