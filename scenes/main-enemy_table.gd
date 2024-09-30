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
  func _init(table: Main_EnemyTable, key: String) -> void:
    listener_instance = (load(key) as PackedScene).instantiate()
    table_row = table.add_row(
      (listener_instance.get_node(^"Sprite2D") as Sprite2D).texture
    )
    table_row.set_text(1, str(listener_instance.hp)) # This’ll never update in this prototype
  
  ## the number of tree instances
  var count := 0:
    set(value):
      count = value
      table_row.visible = count > 0


## Keys: scene path [class String]s; Values: [class Main_EnemyTable.EnemyEntry]s
var entries := {}

func get_entry(key: String) -> EnemyEntry:
  var entry: EnemyEntry = entries.get(key)
  if entry == null:
    entry = EnemyEntry.new(self, key)
    entries[key] = entry
  return entry
