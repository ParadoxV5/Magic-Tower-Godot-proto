class_name Main_EnemyTable extends FibulaPage_Table

## Scrappy Singleton
static var instance: Main_EnemyTable = null
@onready var existing_only_button: BaseButton = $"../ExistingOnlyButton"

func _ready() -> void:
  super()
  instance = self


class EnemyEntry:
  
  ## an undate tracker instance independent from tree instances
  var listener_instance: Enemy
  var table_row : TreeItem
  enum TableColumn {TEXTURE, HP, ATK, DEF, DAMAGE_ESTIMATE, SPECIAL}
  
  func _init(key: String) -> void:
    Main_EnemyTable.instance.existing_only_button.toggled.connect(refresh_visibility)
    listener_instance = (load(key) as PackedScene).instantiate()
    listener_instance._ready() # scrappily call “constructor part 2” without triggering [method Enemy._enter_tree]
    table_row = Main_EnemyTable.instance.add_row(listener_instance)
    table_row.set_text(TableColumn.HP , str(listener_instance.hp)) # This’ll never update in this prototype
    # It seems that we could use a custom [class Signal] system that updates on [method Signal.connect].
    listener_instance.atk_updated.connect(update_cell_atk)
    update_cell_atk(listener_instance.atk)
    listener_instance.def_updated.connect(update_cell_def)
    update_cell_def(listener_instance.def)
    listener_instance.special_updated.connect(update_cell_special)
    update_cell_special(listener_instance.special_description)
    for sig: Signal in [
      listener_instance.atk_updated,
      listener_instance.def_updated,
      # [class Enemy]s load after [member Player.instance].
      Player.instance.atk_updated,
      Player.instance.def_updated,
      Player.instance.absorption_updated,
      Player.instance.enemy_defeated
    ]: sig.connect(refresh_damage_estimate)
    refresh_damage_estimate()
  
  func refresh_visibility(existing_only := Main_EnemyTable.instance.existing_only_button.button_pressed) -> void:
    table_row.visible = !existing_only or count > 0
  ## the number of tree instances
  var count := 0:
    set(value):
      count = value
      refresh_visibility()
  
  func update_cell_atk(value: int) -> void:
    table_row.set_text(TableColumn.ATK, str(value))
  func update_cell_def(value: int) -> void:
    table_row.set_text(TableColumn.DEF, str(value))
  func update_cell_special(value: String) -> void:
    table_row.set_text(TableColumn.SPECIAL, value)
  
  ## see [method Player.estimate_damage]
  func refresh_damage_estimate(_new_value := 0) -> String:
    var display: String
    var estimate := listener_instance.estimate_damage()
    if estimate[0]:
      if estimate.size() > 1:
        var damage := estimate.decode_s64(1)
        display = str(damage) if damage > 0 else "０"
      else:
        display = "∞"
    else:
      display = "／"
    table_row.set_text(TableColumn.DAMAGE_ESTIMATE, display)
    return display
  

## Keys: scene path [class String]s; Values: [class Main_EnemyTable.EnemyEntry]s
var entries := {}

func get_entry(key: String) -> EnemyEntry:
  var entry: EnemyEntry = entries.get(key)
  if entry == null:
    entry = EnemyEntry.new(key)
    entries[key] = entry
  return entry
