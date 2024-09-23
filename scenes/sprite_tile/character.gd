class_name Character extends SpriteTile


@export_group("Stats")

@export var hp: int = 1: set = set_hp # Initialize positive, else it sets 0 on init and dies
func set_hp(value: int) -> int:
  hp = value
  if hp <= 0:
    destroy()
  return hp

@export var atk: int: set = set_atk
func set_atk(value: int) -> int:
  atk = value
  return atk

@export var def: int: set = set_def
func set_def(value: int) -> int:
  def = value
  return def


## Calculate the damage [code]self[/code] gives to [code]other[/code] each strike
## 
## An overridden [code]other.[/code][method get_damage_taken] has precedence over this method; use that instead.
func get_damage_dealt(other: Character) -> int:
  return maxi(atk - other.def, 0)

## Get the (actual) damage [code]self[/code] takes from each strike from [code]other[/code]
## 
## This is most often the same as [code]other.[/code][method get_damage_dealt], but defensive passives may override.
## 
## When checking for stalemate scenarios, also use this method over contrasting [member atk] from [member def],
## as Specials may override this or [code]other.[/code][method get_damage_dealt] to bypass that requirement.
func get_damage_taken(other: Character) -> int:
  return other.get_damage_dealt(self)


## Returns whether the character survives the attack
##
## While not present in this prototype, there are scenarios where the player can
## survive lethal damage, such as having the 十字架 (Cross) item from cos105hk’s
## 魔塔 (commonly known as 新新魔塔) or the Once More passive from CrossCode.
func take_damage(damage: int) -> bool:
  hp -= damage
  return hp > 0

## Extensibility function: currently only [method queue_free]s
func destroy() -> void:
  queue_free()
