class_name Player extends Character

## Not necessarily the Singleton pattern,
## but this would track the [i]current[/i] player if the game has multiple
##
## (Not using signals because this matches the full game plan better –
#   it’s a limitation of this prototype.)
static var instance: Player = null:
  set(value):
    instance = value
    instance.emit_all_updated()


signal hp_updated(hp: int)
func set_hp(value: int) -> int:
  hp_updated.emit(super(value))
  return hp

signal atk_updated(atk: int)
func set_atk(value: int) -> int:
  atk_updated.emit(super(value))
  return atk
  
signal def_updated(def: int)
func set_def(value: int) -> int:
  def_updated.emit(super(value))
  return def

signal absorption_updated(absorption: int)
@export var absorption: int:
  set(value):
    absorption = value
    absorption_updated.emit(absorption)

signal picks_updated(picks: int)
var picks: int:
  set(value):
    picks = value
    picks_updated.emit(picks)

signal bombs_updated(bombs: int)
var bombs: int:
  set(value):
    bombs = value
    bombs_updated.emit(bombs)

func emit_all_updated() -> void:
  # I miss Ruby.
  hp_updated        .emit(hp)
  atk_updated       .emit(atk)
  def_updated       .emit(def)
  absorption_updated.emit(absorption)
  picks_updated     .emit(picks)
  bombs_updated     .emit(bombs)

func _ready() -> void:
  instance = self


# Movement constants
const TILE_SIZE: int = 32
const VELOCITY_4DIR: PackedVector2Array = [
  Vector2(0, TILE_SIZE),
  Vector2(-TILE_SIZE, 0),
  Vector2(TILE_SIZE, 0),
  Vector2(0, -TILE_SIZE)
]
const INPUT_4DIR: PackedStringArray = [
  &"down", &"left", &"right", &"up"
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
  interact_query.collision_mask = 3

func _unhandled_input(event: InputEvent) -> void:
  var direction: int = 0
  while(direction < 4):
    if event.is_action_pressed(INPUT_4DIR[direction], true): # allow echo
      get_viewport().set_input_as_handled()
      return step(direction)
    direction += 1

func step(direction: int) -> void:
  direction = $Sprite2D.set_facing(direction)
  position2 = global_position + VELOCITY_4DIR[direction]
  
  # This game moves in whole tiles only,
  # so point queries are way more [i]direct[/i] than astral-projected hurtboxes.
  var interact_query_results := direct_space.intersect_point(
    # already configured with [method _init] and [member position2]
    interact_query,
    # This prototype only overlap the floor under things,
    # so it only needs 2 `max_results`.
    2
  )
  
  match interact_query_results.size():
    # 0: pass
    1: # Found Floor
      global_position = position2 # move
    2: # Found Floor and Tile
      for interact_query_result: Dictionary in interact_query_results:
        var collider := interact_query_result[&"collider"] as Area2D
        if collider is SpriteTile: # make sure
          if collider.penetrable:
            global_position = position2 # move
          collider._interact()
