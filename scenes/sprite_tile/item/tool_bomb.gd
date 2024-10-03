class_name ToolBomb extends Item

func _interact() -> void:
  Player.instance.bombs += amount
  super()
