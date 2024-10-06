class_name PurifyAvengeEnemy extends Enemy

static var avenge_counter := 0
## Cached by [method estimate_damage]
static var extra_damage := 0

## also updates [member extra_damage] and [member special_description]
## (Only the [member Main_EnemyTable.EnemyEntry.listener_instance] calls this.)
func estimate_damage(player := Player.instance) -> PackedByteArray:
  var ret := super(player)
  if ret[0]:
    extra_damage = player.absorption * 3 + avenge_counter
    special_description = ("在战斗前先造成（玩家护盾×３＋(%i)＝%i）
点伤害，然后这个变量减半（这个变量每在玩家战胜敌物后增加２）").format([avenge_counter, extra_damage], "%i")
    if ret.size() > 1:
      ret.encode_s64(1, ret.decode_s64(1) + extra_damage)
  return ret

func battle(player := Player.instance) -> void:
  if player.take_damage(extra_damage):
    # divide before add (in [code]super[/code])
    # (If the [class Player] fails the main battle, the update signal [signal Player.enemy_defeated]
    # does not emit, so the Fibula [method estimate_damage] does not change.)
    avenge_counter /= 2
    super(player)
