class_name ToolPick extends Item

func _interact() -> void:
  Player.instance.picks += amount
  super()
