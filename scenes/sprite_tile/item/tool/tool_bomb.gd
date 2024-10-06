class_name ToolBomb extends Tool

func _interact() -> void:
  Player.instance.bombs += amount
  super()
