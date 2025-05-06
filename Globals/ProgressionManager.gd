extends Node

var npc_sequence: Array[Dictionary] = [
	{"name": "IntroGuy", "quest_id": "talk_to_introguy", "objective_text": "Talk to Intro Guy"},
	{"name": "IntroGuy", "quest_id": "pickup_2_items", "objective_text": "Pick up the items"},
	{"name": "SlimeTrap", "quest_id": "help_npc", "objective_text": "Kill all the slimes"},
	{"name": "SlimeTrap", "quest_id": "talk_to_slimetrap", "objective_text": "Talk to SlimeTrap"},
	{"name": "TownTrap", "quest_id": "save_towntrap", "objective_text": "Save TownTrap"},
	{"name": "TownTrap", "quest_id": "talk_to_towntrap", "objective_text": "Talk to TownTrap"},
	{"name": "HillBoy", "quest_id": "talk_to_hillguy", "objective_text": "Talk to HillBoy"},
	{"name": "BeforeBoss", "quest_id": "clean_world", "objective_text": "Clean the World"},
	{"name": "BeforeBoss", "quest_id": "talk_to_beforeboss", "objective_text": "Talk to BeforeBoss"},
	{"name": "EndGuy", "quest_id": "kill_boss", "objective_text": "Kill the Boss"},
	{"name": "EndGuy", "quest_id": "talk_to_endguy", "objective_text": "Talk to EndGuy"}
]

var quest_states: Dictionary = {
	"talk_to_introguy": false,
	"pickup_2_items": false,
	"help_npc": false,
	"talk_to_slimetrap": false,
	"save_towntrap": false,
	"talk_to_towntrap": false,
	"talk_to_hillguy": false,
	"clean_world": false,
	"talk_to_beforeboss": false,
	"kill_boss": false,
	"talk_to_endguy": false
}

var quest_functions: Dictionary = {
	"talk_to_introguy": check_talk_to_introguy,
	"pickup_2_items": check_pickup_2_items,
	"help_npc": check_help_npc,
	"talk_to_slimetrap": check_talk_to_slimetrap,
	"save_towntrap": check_save_towntrap,
	"talk_to_towntrap": check_talk_to_towntrap,
	"talk_to_hillguy": check_talk_to_hillguy,
	"clean_world": check_clean_world,
	"talk_to_beforeboss": check_talk_to_beforeboss,
	"kill_boss": check_kill_boss,
	"talk_to_endguy": check_talk_to_endguy
}

var slime_enemies_defeated: int = 0
var trash_collected: int = 0
var melee_enemies_defeated: int = 0

var current_sequence_index: int = 0
var objectives_label: Label = null
var label_search_attempts: int = 0
const MAX_LABEL_SEARCH_ATTEMPTS: int = 50

func _ready():
	# Validate npc_sequence
	for i in range(npc_sequence.size()):
		var entry = npc_sequence[i]
		if not entry is Dictionary or not entry.has("quest_id") or not entry.has("name") or not entry.has("objective_text"):
			push_error("Invalid npc_sequence entry at index " + str(i) + ": " + str(entry))
	# Initialize quest states
	for entry in npc_sequence:
		if entry.has("quest_id") and not quest_states.has(entry.quest_id):
			quest_states[entry.quest_id] = false
	# Connect to Player_spawned signal
	if PlayerManager.has_signal("Player_spawned"):
		PlayerManager.Player_spawned.connect(_on_player_spawned)
	else:
		call_deferred("find_objectives_label")

func _on_player_spawned():
	if PlayerManager.Player_instance:
		find_objectives_label()

func _process(delta):
	if not objectives_label and label_search_attempts < MAX_LABEL_SEARCH_ATTEMPTS:
		label_search_attempts += 1
		find_objectives_label()
	if current_sequence_index < npc_sequence.size():
		var quest_id = npc_sequence[current_sequence_index].quest_id
		if quest_id and not quest_states.get(quest_id, false):
			quest_functions[quest_id].call()

func find_objectives_label():
	if PlayerManager.Player_instance:
		objectives_label = PlayerManager.Player_instance.get_node_or_null("UI Wrapper/HUD/Top/Header/Control/VBoxContainer/Control/MarginContainer/Objectives/Control/HBoxContainer/VBoxContainer/Label2")
		if objectives_label:
			update_objectives_text()
			push_warning("Found Label2 under Player/UI Wrapper")
			return
		objectives_label = PlayerManager.Player_instance.get_node_or_null("UIWrapper/HUD/Top/Header/Control/VBoxContainer/Control/MarginContainer/Objectives/Control/HBoxContainer/VBoxContainer/Label2")
		if objectives_label:
			update_objectives_text()
			push_warning("Found Label2 under Player/UIWrapper")
			return
		objectives_label = get_tree().root.get_node_or_null("UI Wrapper/HUD/Top/Header/Control/VBoxContainer/Control/MarginContainer/Objectives/Control/HBoxContainer/VBoxContainer/Label2")
		if objectives_label:
			update_objectives_text()
			push_warning("Found Label2 under Root/UI Wrapper")
			return
	if label_search_attempts == 1:
		print_scene_tree()

func print_scene_tree():
	var tree = get_tree()
	var root = tree.root
	_print_node(root, 0)

func _print_node(node: Node, depth: int):
	var indent = "  ".repeat(depth)
	for child in node.get_children():
		_print_node(child, depth + 1)

func get_current_npc() -> Node2D:
	if current_sequence_index >= npc_sequence.size():
		return null
	var npcs = get_tree().get_nodes_in_group("NPC")
	var entry = npc_sequence[current_sequence_index]
	var target_name = entry.name
	for npc in npcs:
		if npc and is_instance_valid(npc) and npc.name == target_name:
			if npc.get("TalkTuah") == true:
				if can_advance_sequence():
					current_sequence_index = min(current_sequence_index + 1, npc_sequence.size())
					update_objectives_text()
					return get_current_npc()
				return null
			return npc
	return null

func can_advance_sequence() -> bool:
	if current_sequence_index >= npc_sequence.size():
		return false
	var quest_id = npc_sequence[current_sequence_index].quest_id
	if quest_id == null:
		return true
	return quest_states.get(quest_id, false)

func complete_quest(quest_id: String) -> void:
	if quest_states.has(quest_id):
		if not quest_states[quest_id]:
			quest_states[quest_id] = true
			update_objectives_text()
			var arrows = get_tree().get_nodes_in_group("Arrow")
			for arrow in arrows:
				if arrow.has_method("update_arrow"):
					arrow.update_arrow()

func update_objectives_text():
	if not objectives_label:
		return

	if current_sequence_index >= npc_sequence.size():
		objectives_label.text = "All objectives completed"
		return

	var entry = npc_sequence[current_sequence_index]
	var text = entry["objective_text"]

	match entry["quest_id"]:
		"help_npc":
			text += " (" + str(slime_enemies_defeated) + "/3)"
		"save_towntrap":
			var total = slime_enemies_defeated + melee_enemies_defeated
			text += " (" + str(total) + "/7)"
		"clean_world":
			if PlayerManager.Player_instance:
				var inventory = PlayerManager.Player_instance.get_node_or_null("UI Wrapper/Inventory")
				if inventory:
					text += " (" + str(inventory.Trash) + "/10)"
				else:
					text += " (0/10)"

	objectives_label.text = text

func add_slime_defeated():
	slime_enemies_defeated += 1
	update_objectives_text()
	if current_sequence_index < npc_sequence.size():
		if npc_sequence[current_sequence_index].quest_id == "help_npc":
			check_help_npc()
		if npc_sequence[current_sequence_index].quest_id == "save_towntrap":
			check_save_towntrap()

func add_trash_collected(amount: int):
	trash_collected += amount
	update_objectives_text()
	if current_sequence_index < npc_sequence.size():
		if npc_sequence[current_sequence_index].quest_id == "clean_world":
			check_clean_world()

func add_melee_defeated():
	melee_enemies_defeated += 1
	update_objectives_text()
	if current_sequence_index < npc_sequence.size():
		if npc_sequence[current_sequence_index].quest_id == "save_towntrap":
				check_save_towntrap()

func check_talk_to_introguy():
	var npcs = get_tree().get_nodes_in_group("NPC")
	for npc in npcs:
		if npc.name == "IntroGuy" and npc.get("TalkTuah") == true:
			complete_quest("talk_to_introguy")

func check_pickup_2_items():
	if PlayerManager.Player_instance:
		var inventory = PlayerManager.Player_instance.get_node_or_null("UI Wrapper/Inventory")
		if inventory and inventory.get_item_count() >= 2:
			var obstacles = get_tree().get_nodes_in_group("Obstacles")
			for obstacle in obstacles:
				if obstacle.name == "Area1Obstacle":
					obstacle.queue_free()
			complete_quest("pickup_2_items")
			var blockage = PlayerManager.Player_instance.get_parent().get_node_or_null("TileSet/Part1/Blocks")
			if blockage:
				blockage.queue_free()

func check_help_npc():
	if slime_enemies_defeated >= 3:
		complete_quest("help_npc")
		slime_enemies_defeated = 0

func check_talk_to_slimetrap():
	var npcs = get_tree().get_nodes_in_group("NPC")
	for npc in npcs:
		if npc.name == "SlimeTrap" and npc.get("TalkTuah") == true:
			complete_quest("talk_to_slimetrap")

func check_save_towntrap():
	if slime_enemies_defeated >= 5 and melee_enemies_defeated >= 2:
		complete_quest("save_towntrap")

func check_talk_to_towntrap():
	var npcs = get_tree().get_nodes_in_group("NPC")
	for npc in npcs:
		if npc.name == "TownTrap" and npc.get("TalkTuah") == true:
			var obstacles = get_tree().get_nodes_in_group("Obstacles")
			for obstacle in obstacles:
				if obstacle.name == "TownObstacle":
					obstacle.queue_free()
			complete_quest("talk_to_towntrap")
			var blockage = PlayerManager.Player_instance.get_parent().get_node_or_null("TileSet/Part2/Blocks")
			if blockage:
				blockage.queue_free()

func check_talk_to_hillguy():
	var npcs = get_tree().get_nodes_in_group("NPC")
	for npc in npcs:
		if npc.name == "HillBoy" and npc.get("TalkTuah") == true:
			complete_quest("talk_to_hillguy")

func check_clean_world():
	if PlayerManager.Player_instance:
		var inventory = PlayerManager.Player_instance.get_node_or_null("UI Wrapper/Inventory")
		if inventory and inventory.Trash >= 10:
			complete_quest("clean_world")

func check_talk_to_beforeboss():
	var npcs = get_tree().get_nodes_in_group("NPC")
	for npc in npcs:
		if npc.name == "BeforeBoss" and npc.get("TalkTuah") == true:
			complete_quest("talk_to_beforeboss")

func check_kill_boss():
	var debug_boss_defeated = false
	if debug_boss_defeated:
		complete_quest("kill_boss")

func check_talk_to_endguy():
	var npcs = get_tree().get_nodes_in_group("NPC")
	for npc in npcs:
		if npc.name == "EndGuy" and npc.get("TalkTuah") == true:
			complete_quest("talk_to_endguy")
