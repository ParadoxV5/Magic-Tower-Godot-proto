class_name ToolPick extends Tool

func _interact() -> void:
  Player.instance.picks += amount
  super()
