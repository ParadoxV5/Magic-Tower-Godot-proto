class_name AmountLabel extends Label

func _on_player_stat_updated(value: int) -> void:
  text = str(value)
