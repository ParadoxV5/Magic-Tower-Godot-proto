class_name GemBlue extends Gem

func _interact() -> void:
  Player.instance.def += amount
  super()
