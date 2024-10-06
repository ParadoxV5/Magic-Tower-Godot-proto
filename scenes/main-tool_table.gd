class_name Main_ToolTable extends FibulaPage_Table

@export var collection: TileSetScenesCollectionSource

func _ready() -> void:
  super()
  for i in collection.get_scene_tiles_count():
    var item: Item = collection.get_scene_tile_scene(
      collection.get_scene_tile_id(i)
    ).instantiate()
    var row := add_row(item)
    row.set_text(1, item.explain())
    item.free()
