class_name Player_Sprite2D extends Sprite2D

@export_group("Textures")
var textures: Array[Texture2D] = [texture, null, null, null]
@export var texture_left:  Texture2D:
  set(value): textures[1] = value
@export var texture_right: Texture2D:
  set(value): textures[2] = value
@export var texture_up:    Texture2D:
  set(value): textures[3] = value

func set_facing(direction: int) -> int:
  direction %= 4
  texture = textures[direction]
  return direction
