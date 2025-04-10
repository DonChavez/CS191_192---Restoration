extends ItemObject

@onready var DASH_COOLDOWN: int

func _ready() -> void:
	super()
	apply_tier(Item_tier)
	Title = Tier_to_text[Item_tier]+" "+Item_name
	Description = "Allows Dashing with 'Shift', higher tier has lower cooldown."
	if Stacking:
		Description += " (Stacks)"
	else:
		Description += " (Does not stack)"
func apply_tier(Tier:int) -> void:
	match Tier:
		0:
			DASH_COOLDOWN = 0 # Common White
			Icon.texture = load("res://Art/Items/dash_1.png")
		1:
			DASH_COOLDOWN = 0 # Uncommon Green
			Icon.texture = load("res://Art/Items/dash_2.png")
		2:
			DASH_COOLDOWN = 1  # Rare Blue
			Icon.texture = load("res://Art/Items/dash_3.png")
		3:
			DASH_COOLDOWN = 0.8  # Epic Purple
			Icon.texture = load("res://Art/Items/dash_4.png")
		4:
			DASH_COOLDOWN = 0.6  # Legendary Red
			Icon.texture = load("res://Art/Items/dash_5.png")

func apply_effect(Player:CharacterBody2D):
	if !Effect_applied:
		Player.toggle_dash(true)
		Player.set_dash_cooldown(DASH_COOLDOWN)
		Effect_applied = true

func remove_effect(Player:CharacterBody2D):
	Player.toggle_dash(false)
	Player.set_dash_cooldown(0)
	Effect_applied = false
