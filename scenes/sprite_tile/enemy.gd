class_name Enemy extends Character

## Enum for [member turn_order]
enum Turn {ENEMY, PLAYER}
## Prototype turn system
## 
## A full game would be programmatic rather than data-driven.
@export var turn_order: Array[Turn] = [Turn.PLAYER, Turn.ENEMY]


## Opening only one scene is still a scene transition.
func _enter_tree() -> void:
  Main_EnemyTable.instance.get_entry(scene_file_path).count += 1
## also includes when [method free]d, unlike [method _enter_tree]
func _exit_tree() -> void:
  Main_EnemyTable.instance.get_entry(scene_file_path).count -= 1


## From the given number of attacks the [code]player[/code] requires to take [code]self[/code] down,
## estimate (read: calculate) the number of attacks [code]self[/code] gives to [code]player[/code] during such battle
## 
## This is most often 1 less than [code]player_attacks[/code].
## As with [member turn_order], a full game would be more programmatic.
## 
## This is for [method estimate_damage] only; it’s not used for [method battle]. As such,
## this amount ignores [member Player.hp] capacity or whether [code]self[/code]’s strikes actually deal damage.
func estimate_counterattacks(player_attacks: int) -> int:
  return player_attacks - 1

## Divide rounding up
## 
## Caution: [class int] overflows if [code]divisor[/code] is the negative limit
## 
## Based on https://github.com/ruby/ruby/pull/5965#issuecomment-1192093000
static func ceildiv(dividend: int, divisor: int) -> int:
  @warning_ignore("integer_division")
  return -(dividend / -divisor)
## Estimate the total battle damage for reference on the
## Fibula without considering [code]player[/code] HP limitations
## 
## The first byte of the return indicates whether an estimate is available ([code]bool[/code]).
## [code]true[/code] precedes the estimate amount ([class int]) if it’s finite,
## or nothing if it’s the estimate is infinite
## (because the [code]player[/code] can’t damage [code]self[/code] but not vice versa).
## In this prototype, the only unavailable ([code]false[/code]) case is when neither can damage the other.
## 
## This estimate differs from [method battle] in that this uses a Θ(1) formula while that simulates each strike.
## This system is similar to that of cos105hk’s 魔塔 (commonly known as 新新魔塔) series,
## where Specials and RNG can deviate the outcome from 心鏡’s estimate;
## although this prototype (and nearly all modern 魔塔 (Magic Tower) games) don’t have such inconsistent Specials.
func estimate_damage(player := Player.instance) -> PackedByteArray:
  var damage_taken :=   self.get_damage_taken(player)
  var damage_dealt := player.get_damage_taken(self)
  if damage_taken <= 0: # [code]player[/code] cannot defeat [code]self[/code]
    return [damage_dealt > 0] # whether [code]self[/code] can defeat [code]player[/code]
  var player_attacks := ceildiv(hp, damage_taken)
  var ret: PackedByteArray = [true]
  ret.resize(9) # [code]ret.size()[/code] + [code]sizeof(int)[/code]
  ret.encode_s64( # [class int] is signed 64-bit
    1, # From index 1 (i.e., skip the 1st byte, which is the [code]bool[/code])
    estimate_counterattacks(player_attacks) * damage_dealt
  )
  return ret

## Even though this method can simply subtract the formula-derived [method estimate_damage]
## as with most modern 魔塔 (Magic Tower) games,
## I chose to actually simulate a turn-based battle so game-over HPs can be realistic negatives.
## This design (in a full game) also grants extra extensibility, especially for 蓝海 designs.
func battle(player := Player.instance) -> void:
  var damage_taken :=   self.get_damage_taken(player)
  var damage_dealt := player.get_damage_taken(self)
  if damage_taken <= 0 and damage_dealt <= 0:
    return prints("Neither the player nor", self, "can take the other down.")
  player.absorption_remaining = player.absorption
  while turn_order.all(func(turn: Turn) -> bool: return( # I dislike Python ternary.
    take_damage(damage_taken) if turn     # [code]Turn.PLAYER[/code]
    else player.take_damage(damage_dealt) # [code]Turn.ENEMY[/code]
  )): pass # The loop body is inside the condition


func bomb(player := Player.instance) -> void:
  #TODO
  destroy()

func _interact() -> void:
  if false: #TODO
    bomb()
  else:
    battle()
