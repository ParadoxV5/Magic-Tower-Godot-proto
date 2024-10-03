class_name Wall extends SpriteTile

func _interact() -> void:
  var player := Player.instance
  if player.is_tooling(Player.Tool.PICK):
    player.spend_tool(Player.Tool.PICK)
    queue_free()
  else:
    super()
