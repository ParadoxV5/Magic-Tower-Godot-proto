class_name FibulaPage_Table extends Tree

@export var column_titles: PackedStringArray = ["图像"]

@onready var tree_root: TreeItem = create_item()

func _ready() -> void:
  columns = column_titles.size()
  for i in columns:
    set_column_title(i, column_titles[i])


## [code]cells[/code] should be the first entry less than [member column_titles].
func add_row(icon: Texture2D, cells: Array[String]) -> TreeItem:
  var row := create_item(tree_root)
  row.set_cell_mode(0, TreeItem.CELL_MODE_ICON)
  row.set_icon(0, icon)
  for i in cells.size():
    row.set_text(i+1, cells[i])
  return row
