class_name Main_EnemyTable extends FibulaPage_Table

## Scrappy Singleton
static var instance: Main_EnemyTable = null

func _ready() -> void:
  super()
  instance = self


class EnemyEntry:
  
  ## an undate tracker instance independent from tree instances
  var listener_instance: Enemy
  var table_row : TreeItem
  enum TableColumn {TEXTURE, HP, ATK, DEF, DAMAGE_ESTIMATE, SPECIAL}
  
  func _init(table: Main_EnemyTable, key: String) -> void:
    listener_instance = (load(key) as PackedScene).instantiate()
    table_row = table.add_row(
      (listener_instance.get_node(^"Sprite2D") as Sprite2D).texture
    )
    table_row.set_text(TableColumn.HP , str(listener_instance.hp)) # This’ll never update in this prototype
    # It seems that we could use a custom [class Signal] system that updates on [method Signal.connect].
    listener_instance.atk_updated.connect(update_cell_atk)
    update_cell_atk(listener_instance.atk)
    listener_instance.def_updated.connect(update_cell_def)
    update_cell_def(listener_instance.def)
    listener_instance.special_updated.connect(update_cell_special)
    update_cell_special(listener_instance.special_description)
    for sig: Signal in [
      listener_instance.atk_updated    ,
      listener_instance.def_updated    ,
      listener_instance.special_updated,
      # [class Enemy]s load after [member Player.instance].
      Player.instance.atk_updated,
      Player.instance.def_updated,
      Player.instance.absorption_updated
    ]: sig.connect(refresh_damage_estimate)
    refresh_damage_estimate()
  
  ## the number of tree instances
  var count := 0:
    set(value):
      count = value
      table_row.visible = count > 0
  
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
        display = str(estimate.decode_s64(1))
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
    entry = EnemyEntry.new(self, key)
    entries[key] = entry
  return entry
