extends Control

@onready var sword: Control = $HBoxContainer/Sword
@onready var bow: Control = $HBoxContainer/Bow
@onready var dash: Control = $HBoxContainer/Dash

func _ready():
	# Initial update to set visibility
	update_weapon_visibility()

func _process(_delta):
	# Constantly check and update visibility
	update_weapon_visibility()

func update_weapon_visibility():
	if PlayerManager.Player_instance != null:
		sword.visible = PlayerManager.Player_instance.Has_melee
		bow.visible = PlayerManager.Player_instance.Has_range
		dash.visible = PlayerManager.Player_instance.Can_dash
	else:
		sword.visible = false
		bow.visible = false
		dash.visible = false
