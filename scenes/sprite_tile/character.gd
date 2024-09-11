class_name Character extends "../sprite_tile.gd"


@export_group("Stats")

@export var hp: int: get = get_hp, set = set_hp
func get_hp() -> int: return hp
func set_hp(value: int) -> int:
  hp = value
  return hp

@export var atk: int: get = get_atk, set = set_atk
func get_atk() -> int: return atk
func set_atk(value: int) -> int:
  atk = value
  return atk

@export var def: int: get = get_def, set = set_def
func get_def() -> int: return def
func set_def(value: int) -> int:
  def = value
  return def
