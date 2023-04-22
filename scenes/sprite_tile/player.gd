extends "res://scenes/sprite_tile.gd"

@export_group("Textures")
var textures: Array[Texture2D] = [texture, null, null, null]
@export var texture_left: Texture2D:
  set(value): textures[1] = value
@export var texture_right: Texture2D:
  set(value): textures[2] = value
@export var texture_up: Texture2D:
  set(value): textures[3] = value
