class_name Gem extends Item

@export var stat_label: String

func explain() -> String:
  return "获得{amount}点{stat_label}".format({"stat_label": stat_label, "amount": amount})
