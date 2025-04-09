extends ItemObject

@onready var RADIUS: float
@onready var Damage: float

@onready var Fire_hurtbox_scene: PackedScene = preload("res://Scenes/Items/FireTankHurtbox.tscn")
@onready var Fire_hurtbox_instance: HurtboxComponent = null


func _calculate_damage(Health:float) -> void:
	Damage = Health * 0.25
	Fire_hurtbox_instance.hurtbox_implement_damage(Damage)

func update_item_status() -> void:
	if User:
		_calculate_damage(User.find_used_max_health())

func _ready() -> void:
	super()
	apply_tier(Item_tier)
	Title = Tier_to_text[Item_tier]+" "+Item_name
	Description = "Deals (25% Player Max Health) damage to all enemies within a radius of "+str(RADIUS)+"." 
	if Stacking:
		Description += " (Stacks)"
	else:
		Description += " (Does not stack)"

func apply_tier(Tier:int) -> void:
	super(Tier)
	match Tier:
		0:
			RADIUS = 0  # Common White
			Icon.texture = load("res://Art/Items/tank_1.png")
		1:
			RADIUS = 0  # Uncommon Green
			Icon.texture = load("res://Art/Items/tank_2.png")
		2:
			RADIUS = 0  # Rare Blue
			Icon.texture = load("res://Art/Items/tank_3.png")
		3:
			RADIUS = 40  # Epic Purple
			Icon.texture = load("res://Art/Items/tank_4.png")
		4:
			RADIUS = 60  # Legendary Red
			Icon.texture = load("res://Art/Items/tank_5.png")

func apply_effect(Player:CharacterBody2D):
	User = Player
	if !Effect_applied:
		Player.toggle_can_attack()
		Fire_hurtbox_instance = Fire_hurtbox_scene.instantiate()
		Player.add_child(Fire_hurtbox_instance)
		Fire_hurtbox_instance.change_size(RADIUS)
		_calculate_damage(Player.find_used_max_health())
		Effect_applied = true

func remove_effect(Player:CharacterBody2D):
	Player.toggle_can_attack()
	Fire_hurtbox_instance.queue_free()
	Effect_applied = false
