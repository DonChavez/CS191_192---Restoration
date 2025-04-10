extends ItemObject

@onready var ADDITIONAL_LIFE_COUNT: int


func _ready() -> void:
	super()
	apply_tier(Item_tier)
	Title = Tier_to_text[Item_tier]+" "+Item_name
	Description = "Projectiles exists for an additional "+str(ADDITIONAL_LIFE_COUNT)+" seconds."
	if Stacking:
		Description += " (Stacks)"
	else:
		Description += " (Does not stack)"

func apply_tier(Tier:int) -> void:
	super(Tier)
	match Tier:
		0:
			ADDITIONAL_LIFE_COUNT = 1  # Common White
			Icon.texture = load("res://Art/Items/ProjectileLife.png")
		1:
			ADDITIONAL_LIFE_COUNT = 2  # Uncommon Green
			Icon.texture = load("res://Art/Items/ProjectileLife.png")
		2:
			ADDITIONAL_LIFE_COUNT = 3  # Rare Blue
			Icon.texture = load("res://Art/Items/ProjectileLife.png")
		3:
			ADDITIONAL_LIFE_COUNT = 4  # Epic Purple
			Icon.texture = load("res://Art/Items/ProjectileLife.png")
		4:
			ADDITIONAL_LIFE_COUNT = 5  # Legendary Red
			Icon.texture = load("res://Art/Items/ProjectileLife.png")

func apply_effect(Player:CharacterBody2D):
	if !Effect_applied:
		Player.add_used_live_time_addition(ADDITIONAL_LIFE_COUNT)
		Effect_applied = true

func remove_effect(Player:CharacterBody2D):
	Player.add_used_live_time_addition(-ADDITIONAL_LIFE_COUNT)
	Effect_applied = false
