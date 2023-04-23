extends "../sprite_tile.gd"

@export_group("Textures")
var textures: Array[Texture2D] = [texture, null, null, null]
@export var texture_left: Texture2D:
  set(value): textures[1] = value
@export var texture_right: Texture2D:
  set(value): textures[2] = value
@export var texture_up: Texture2D:
  set(value): textures[3] = value

const TILE_SIZE: int = 32
const VELOCITY_4DIR: PackedVector2Array = [
  Vector2(0, TILE_SIZE),
  Vector2(-TILE_SIZE, 0),
  Vector2(TILE_SIZE, 0),
  Vector2(0, -TILE_SIZE)
]
const INPUT_4DIR: PackedStringArray = [
  &"ui_down", &"ui_left", &"ui_right", &"ui_up"
]
func _unhandled_input(event: InputEvent) -> void:
  var facing2: int = 0
  while(facing2 < 4):
    if event.is_action_pressed(INPUT_4DIR[facing2]):
      texture = textures[facing2]
      var position2: Vector2 = position + VELOCITY_4DIR[facing2]
      position = position2 # XXX: Future-proof
      return
    facing2 += 1
