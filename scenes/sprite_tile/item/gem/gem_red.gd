class_name GemRed extends Gem

func _interact() -> void:
  Player.instance.atk += amount
  super()
