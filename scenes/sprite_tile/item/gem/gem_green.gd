class_name GemGreen extends Gem

func _interact() -> void:
  Player.instance.absorption += amount
  super()
