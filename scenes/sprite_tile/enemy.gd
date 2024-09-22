class_name Enemy extends Character


## Estimate the total battle damage for reference on the
## Fibula without considering [code]player[/code] HP limitations
## 
## The first byte of the return indicates whether an estimate is available ([code]bool[/code]).
## [code]true[/code] precedes the estimate amount (`int`) if it’s finite,
## or nothing if it’s the estimate is infinite (due to insufficient Player ATK but sufficient Enemy ATK).
## In this prototype,
## the only unavailable ([code]false[/code]) case is when both parties tie because neither has sufficient ATK.
func estimate_damage(player := Player.instance) -> PackedByteArray:
  return [false] #TODO

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
