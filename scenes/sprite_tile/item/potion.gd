class_name Potion extends Item

func _interact() -> void:
  Player.instance.hp += amount
  super()
