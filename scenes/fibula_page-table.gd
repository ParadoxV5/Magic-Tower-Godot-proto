class_name FibulaPage_Table extends Tree

@export var column_titles: PackedStringArray = ["图像"]
var last_column_id := -1

@onready var tree_root: TreeItem = create_item()

func _ready() -> void:
  columns = column_titles.size()
  for i in columns:
    set_column_expand(i, false)
    set_column_title_alignment(i, HORIZONTAL_ALIGNMENT_CENTER)
    set_column_title(i, column_titles[i])
  last_column_id = columns-1
  set_column_expand(last_column_id, true)
  set_column_title_alignment(last_column_id, HORIZONTAL_ALIGNMENT_LEFT)


## [code]cells[/code] should be the first entry less than [member column_titles].
func add_row(icon: Texture2D) -> TreeItem:
  var row := create_item(tree_root)
  for i in columns:
    row.set_text_alignment(i, HORIZONTAL_ALIGNMENT_RIGHT)
    row.set_text_overrun_behavior(i, TextServer.OVERRUN_NO_TRIMMING)
  row.set_text_alignment(0, HORIZONTAL_ALIGNMENT_CENTER)
  row.set_text_alignment(last_column_id, HORIZONTAL_ALIGNMENT_LEFT)
  row.set_cell_mode(0, TreeItem.CELL_MODE_ICON)
  row.set_icon(0, icon)
  return row
