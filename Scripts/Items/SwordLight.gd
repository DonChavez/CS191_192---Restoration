extends ItemObject

@onready var X_Value: float
@onready var Y_Value: float

@onready var Damage: float

@onready var Light_hitbox_scene: PackedScene = preload("res://Scenes/Items/SwordLightHitbox.tscn")
@onready var Light_hitbox_instance: HitboxComponent = null

#func update_item_status() -> void:
#	_calculate_damage(User.find_used_max_health())


func _ready() -> void:
	super()
	apply_tier(Item_tier)
	Title = Tier_to_text[Item_tier]+" "+Item_name
	Description = "No longer able to block, attacks can now parry projectiles and hits from enemies." 
	if Stacking:
		Description += " (Stacks)"
	else:
		Description += " (Does not stack)"

func apply_tier(Tier:int) -> void:
	super(Tier)
	match Tier:
		0:
			X_Value = 0  # Common White
			Icon.texture = load("res://Art/Items/parry_1.png")
		1:
			X_Value = 0  # Uncommon Green
			Icon.texture = load("res://Art/Items/parry_2.png")
		2:
			X_Value = 0  # Rare Blue
			Icon.texture = load("res://Art/Items/parry_3.png")
		3:
			X_Value = 40  # Epic Purple
			Icon.texture = load("res://Art/Items/parry_4.png")
		4:
			X_Value = 60  # Legendary Red
			Icon.texture = load("res://Art/Items/parry_5.png")

func apply_effect(Player:CharacterBody2D):
	if !Effect_applied:
		Player.toggle_can_block()
		Player.apply_melee_weapon(0, 0, Item_name, 1)
		Light_hitbox_instance = Light_hitbox_scene.instantiate()
		Player.add_child(Light_hitbox_instance)
		Player.apply_light_sword(Light_hitbox_instance)
		Effect_applied = true

func remove_effect(Player:CharacterBody2D):
	Player.toggle_can_block()
	Player.apply_melee_weapon(0, 0, Item_name, 0)
	Player.toggle_parry()
	Player.apply_light_sword(null)
	Light_hitbox_instance.queue_free()
	Effect_applied = false
