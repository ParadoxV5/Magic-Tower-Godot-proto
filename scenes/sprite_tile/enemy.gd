class_name Enemy extends Character

## Prototype turn system
## 
## A full game will be programmatic rather than data-driven.
@export_enum("Enemy Turn", "Player Turn") var turn_order: PackedByteArray = [1, 0]


## From the given [method Player.estimate_attacks],
## estimate (read: calculate) the number of attacks [code]self[/code] gives to [code]player[/code] during a battle;
## continue returning a negative number if it’s unbounded because [code]player[/code] has insufficient ATK
## 
## This is most often 1 less than [code]player_attacks[/code].
## 
## This is for [method estimate_damage] only; it’s not used for [method Enemy.battle]. As such,
## this amount does not consider [code]player[/code] HP limitations or if it[code]self[/code] has insufficient ATK.
func estimate_counterattacks(player_attacks: int) -> int:
  return player_attacks - 1

## Estimate the total battle damage for reference on the
## Fibula without considering [code]player[/code] HP limitations
## 
## The first byte of the return indicates whether an estimate is available ([code]bool[/code]).
## [code]true[/code] precedes the estimate amount (`int`) if it’s finite,
## or nothing if it’s the estimate is infinite (due to insufficient Player ATK but sufficient Enemy ATK).
## In this prototype,
## the only unavailable ([code]false[/code]) case is when both parties tie because neither has sufficient ATK.
## 
## This estimate differs from [method battle] in that this uses a Θ(1) formula while that simulates each strike.
## This system is simular to that of cos105hk’s 魔塔 (commonly known as 新新魔塔) series,
## where specials and RNG can deviate the outcome from 心鏡’s estimate,
## although this prototype (and nearly all modern 魔塔 (Magic Tower) games) don’t have such inconsistent specials.
func estimate_damage(player := Player.instance) -> PackedByteArray:
  return [false] #TODO


## Even though this method can simply subtract the formula-derived [method estimate_damage]
## as with most modern 魔塔 (Magic Tower) games,
## I chose to actually simulate a turn-based battle so game-over HPs can be realistic negatives.
## This design (in a full game) also grants extra extensibility, especially for 蓝海 designs.
func battle(player := Player.instance) -> void:
  pass #TODO


func bomb(player := Player.instance) -> void:
  #TODO
  destroy()

## Extensibility function: currently only [method queue_free]s
func destroy() -> void:
  queue_free()

func _interact() -> void:
  if false: #TODO
    bomb()
  else:
    battle()
