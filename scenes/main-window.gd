class_name Main_Window extends Window

func _shortcut_input(event: InputEvent) -> void:
  if event.is_action_pressed(&"fibula"):
    get_viewport().set_input_as_handled()
    close_requested.emit()
