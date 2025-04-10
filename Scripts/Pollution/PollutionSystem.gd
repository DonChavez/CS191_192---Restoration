extends Control

signal LessThanHalf

@onready var PollutionLevel: ProgressBar = $PollutionLevel

signal pollution_updated(value: float)

var Max_pollution : float = 100.0
var Current_pollution : float = 0.0

var pollution_level: int = 0  # Tracks the current pollution level

func _ready():
	# current pollution value
	Current_pollution = Max_pollution
	PollutionLevel.value = Current_pollution
	
	# Connect to the scene tree's node_added signal to detect new trash
	get_tree().connect("node_added", Callable(self, "_on_node_added"))
	
	# Connect to any existing trash items at startup
	connect_to_existing_trash()

func _process(delta: float) -> void:
	if Current_pollution < 50.0:
		LessThanHalf.emit()

func connect_to_existing_trash():
	# Connect to any trash items already in the group
	var trash_items = get_tree().get_nodes_in_group("PollutionReduction")
	for trash in trash_items:
		trash.EATTRASH.connect(Callable(self, "_on_trash_affected"))

func _on_node_added(node):
	# Check if the new node is in the "trash_items" group
	if node.is_in_group("PollutionReduction"):
		node.EATTRASH.connect(Callable(self, "_on_trash_affected"))

func _on_trash_affected(amount: int):
	Current_pollution -= amount
	PollutionLevel.value = Current_pollution
	emit_signal("pollution_updated", Current_pollution)  # Emit pollution change
	print("Pollution level changed by ", amount, ". New level: ", Current_pollution)
