class_name GemRed extends Item

func _interact() -> void:
  Player.instance.atk += amount
  super()
