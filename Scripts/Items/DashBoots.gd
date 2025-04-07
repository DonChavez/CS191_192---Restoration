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
	super(Tier)
	match Tier:
		0:
			DASH_COOLDOWN = 0 # Common White
		1:
			DASH_COOLDOWN = 0 # Uncommon Green
		2:
			DASH_COOLDOWN = 1  # Rare Blue
		3:
			DASH_COOLDOWN = 0.8  # Epic Purple
		4:
			DASH_COOLDOWN = 0.6  # Legendary Red

func apply_effect(Player:CharacterBody2D):
	if !Effect_applied:
		Player.toggle_dash(true)
		Player.set_dash_cooldown(DASH_COOLDOWN)
		Effect_applied = true

func remove_effect(Player:CharacterBody2D):
	Player.toggle_dash(false)
	Player.set_dash_cooldown(0)
	Effect_applied = false
