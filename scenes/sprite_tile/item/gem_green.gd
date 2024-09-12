class_name GemGreen extends Item

func _interact() -> void:
  Player.instance.absorption += amount
  super()
