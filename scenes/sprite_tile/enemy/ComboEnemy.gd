class_name ComboEnemy extends Enemy

func estimate_counterattacks(player_attacks: int) -> int:
  return super(player_attacks) * 2
