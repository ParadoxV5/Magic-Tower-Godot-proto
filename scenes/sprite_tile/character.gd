class_name Character extends SpriteTile


@export_group("Stats")

@export var hp: int: set = set_hp
func set_hp(value: int) -> int:
  hp = value
  return hp

@export var atk: int: set = set_atk
func set_atk(value: int) -> int:
  atk = value
  return atk

@export var def: int: set = set_def
func set_def(value: int) -> int:
  def = value
  return def


func get_damage_dealt(other: Character) -> int:
  return maxi(atk - other.def, 0)

## Returns whether the character survives the attack
func take_damage(damage: int) -> bool:
  hp -= damage
  return hp > 0
