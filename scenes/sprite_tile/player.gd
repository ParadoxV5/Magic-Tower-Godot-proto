class_name Player extends "../sprite_tile.gd"

# Movement constants
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

# Caches for [method _unhandled_input]
@onready var direct_space :=\
  PhysicsServer2D.space_get_direct_state(get_world_2d().space)
var interact_query: PhysicsPointQueryParameters2D = null
## Convenience for [method _unhandled_input]
var position2: Vector2:
  get(): return interact_query.position
  set(value): interact_query.position = value

func _init() -> void:
  # init [member interact_query]
  interact_query = PhysicsPointQueryParameters2D.new()
  interact_query.collide_with_areas = true # This game uses [Area2D]s …
  interact_query.collide_with_bodies = false # … not [PhysicsBody2D]s
  interact_query.collision_mask = 1

func _unhandled_input(event: InputEvent) -> void:
  var direction: int = 0
  while(direction < 4):
    if event.is_action_pressed(INPUT_4DIR[direction]):
      return step(direction)
    direction += 1

func step(direction: int) -> void:
  direction = $Sprite2D.set_facing(direction)
  position2 = global_position + VELOCITY_4DIR[direction]
  
  # This game moves in whole tiles only,
  # so point queries are way more [i]direct[/i] than astral-projected hurtboxes.
  var interact_query_results := direct_space.intersect_point(
    interact_query, # already configured with [method _init] and [member position2]
    1 # This prototype doesn’t overlap things, so it only needs 1 `max_results`.
  )
  
  if interact_query_results.is_empty():
    global_position = position2 # move
  else: # one
    var collider := interact_query_results.front()[&"collider"] as Area2D
    if collider is SpriteTile: # make sure
      if collider.penetrable:
        global_position = position2 # move
      collider._interact()
