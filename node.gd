extends Node


var pollution_level: int = 0  # Tracks the current pollution level

func _ready():
	# Connect to the scene tree's node_added signal to detect new trash
	get_tree().connect("node_added", Callable(self, "_on_node_added"))
	
	# Connect to any existing trash items at startup
	connect_to_existing_trash()

func connect_to_existing_trash():
	# Connect to any trash items already in the group
	var trash_items = get_tree().get_nodes_in_group("trash_items")
	for trash in trash_items:
		trash.EATTRASH.connect(Callable(self, "_on_trash_affected"))

func _on_node_added(node):
	# Check if the new node is in the "trash_items" group
	if node.is_in_group("trash_items"):
		node.EATTRASH.connect(Callable(self, "_on_trash_affected"))

func _on_trash_affected(amount: int):
	print("Pollution level changed by ", amount, ". New level: ", pollution_level)
	# Add your logic here (e.g., update UI, trigger events if pollution is too high)
