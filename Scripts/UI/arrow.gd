extends Control

@onready var arrow: TextureRect = $TextureRect
@export var fixed_arrow_pos: Vector2 = Vector2.ZERO
@export var pivot_point: Vector2 = Vector2(0.5, 0.5)
@export var hide_radius: float = 0

var nearest_npc: Node2D = null
var custom_target: Node2D = null
var dialogue_npc: Node2D = null

func _ready():
	if arrow:
		arrow.visible = true
		var scaled_size = arrow.size * arrow.scale
		arrow.pivot_offset = Vector2(scaled_size.x * pivot_point.x, scaled_size.y * pivot_point.y)
		if fixed_arrow_pos != Vector2.ZERO:
			position = fixed_arrow_pos - arrow.pivot_offset
	validate_scene_setup()
	DialogueManager.dialogue_started.connect(_on_dialogue_started)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	add_to_group("Arrow")
	update_arrow()

func _process(_delta):
	update_arrow()

func validate_scene_setup():
	if arrow == null:
		push_error("TextureRect not found at $TextureRect")
		return
	if arrow.texture == null:
		push_warning("TextureRect has no texture")
	if arrow.size == Vector2.ZERO:
		push_warning("TextureRect has zero size")

func update_arrow():
	clear_all_glows()
	if DialogueState.is_dialogue_active:
		arrow.visible = false
		nearest_npc = null
		return
	if PlayerManager.Player_instance == null:
		arrow.visible = false
		nearest_npc = null
		return

	var player_pos = PlayerManager.Player_instance.global_position
	if custom_target and is_instance_valid(custom_target) and custom_target.get("TalkTuah") == false and custom_target != dialogue_npc:
		nearest_npc = custom_target
	else:
		nearest_npc = ProgressionManager.get_current_npc()

	if nearest_npc == null:
		arrow.visible = false
		return

	if nearest_npc.has_method("set_glow"):
		nearest_npc.set_glow(true)

	var npc_pos = nearest_npc.global_position
	if player_pos.distance_to(npc_pos) <= hide_radius:
		arrow.visible = false
		return

	arrow.visible = true
	var direction = (npc_pos - player_pos).normalized()
	arrow.rotation = direction.angle()

func clear_all_glows():
	var npcs = get_tree().get_nodes_in_group("NPC")
	for npc in npcs:
		if npc and is_instance_valid(npc) and npc.has_method("set_glow"):
			npc.set_glow(false)

func set_custom_target(npc: Node2D) -> void:
	custom_target = npc
	clear_all_glows()
	nearest_npc = null
	if npc and is_instance_valid(npc) and npc.has_method("set_glow") and npc.get("TalkTuah") == false and npc != dialogue_npc:
		nearest_npc = npc
		npc.set_glow(true)
	update_arrow()

func _on_dialogue_started(_resource: DialogueResource):
	if PlayerManager.Player_instance:
		var player_pos = PlayerManager.Player_instance.global_position
		var npcs = get_tree().get_nodes_in_group("NPC")
		var min_dist_squared = INF
		dialogue_npc = null
		for npc in npcs:
			if npc == null or not is_instance_valid(npc) or not npc is Node2D or npc.get("TalkTuah") == true:
				continue
			var dist_squared = player_pos.distance_squared_to(npc.global_position)
			if dist_squared < min_dist_squared and dist_squared < 10000:
				min_dist_squared = dist_squared
				dialogue_npc = npc
	clear_all_glows()
	nearest_npc = null
	update_arrow()

func _on_dialogue_ended(_resource: DialogueResource):
	dialogue_npc = null
	clear_all_glows()
	update_arrow()
