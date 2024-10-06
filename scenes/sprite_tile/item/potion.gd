class_name Potion extends Item

func explain() -> String:
  return "补充%i点生命值".format([amount], "%i")

func _interact() -> void:
  Player.instance.hp += amount
  super()
