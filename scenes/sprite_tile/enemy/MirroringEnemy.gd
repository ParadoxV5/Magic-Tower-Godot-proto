class_name MirroringEnemy extends Enemy

func _on_player_atk_updated(player_atk: int) -> void:
  atk = player_atk
func _on_player_def_updated(player_def: int) -> void:
  def = player_def

func _ready() -> void:
  super()
  Player.instance.atk_updated.connect(_on_player_atk_updated)
  Player.instance.def_updated.connect(_on_player_def_updated)
  _on_player_atk_updated(Player.instance.atk)
  _on_player_def_updated(Player.instance.def)
