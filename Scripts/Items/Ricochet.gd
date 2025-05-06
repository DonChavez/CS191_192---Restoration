extends ItemObject

@onready var ADDITIONAL_BOUNCE_COUNT: int


func _ready() -> void:
	super()
	apply_tier(Item_tier)
	Title = Tier_to_text[Item_tier]+" "+Item_name
	Description = "Projectiles bounces off of objects "+str(ADDITIONAL_BOUNCE_COUNT)+" time."
	if Stacking:
		Description += " (Stacks)"
	else:
		Description += " (Does not stack)"

func apply_tier(Tier:int) -> void:
	super(Tier)
	match Tier:
		0:
			ADDITIONAL_BOUNCE_COUNT = 1  # Common White
			Icon.texture = load("res://Art/Items/ricochet_1.png")
		1:
			ADDITIONAL_BOUNCE_COUNT = 2  # Uncommon Green
			Icon.texture = load("res://Art/Items/ricochet_2.png")
		2:
			ADDITIONAL_BOUNCE_COUNT = 3  # Rare Blue
			Icon.texture = load("res://Art/Items/ricochet_3.png")
		3:
			ADDITIONAL_BOUNCE_COUNT = 4  # Epic Purple
			Icon.texture = load("res://Art/Items/ricochet_4.png")
		4:
			ADDITIONAL_BOUNCE_COUNT = 5  # Legendary Red
			Icon.texture = load("res://Art/Items/ricochet_5.png")

func apply_effect(Player:CharacterBody2D):
	if !Effect_applied:
		Player.add_used_projectile_bounce_count(ADDITIONAL_BOUNCE_COUNT)
		Effect_applied = true

func remove_effect(Player:CharacterBody2D):
	Player.add_used_projectile_bounce_count(-ADDITIONAL_BOUNCE_COUNT)
	Effect_applied = false
