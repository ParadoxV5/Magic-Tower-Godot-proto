class_name FirstStrikeComboEnemy extends Enemy

func estimate_counterattacks(player_attacks: int) -> int:
  return player_attacks * 2
