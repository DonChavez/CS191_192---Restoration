extends ItemObject

@onready var ADDITIONAL_SPREAD_SHOT_COUNT: int

func _ready() -> void:
	super()
	apply_tier(Item_tier)
	Title = Tier_to_text[Item_tier]+" "+Item_name
	Description = "Shoot "+str(ADDITIONAL_SPREAD_SHOT_COUNT)+" additional projectiles in a cone."
	if Stacking:
		Description += " (Stacks)"
	else:
		Description += " (Does not stack)"
		
func apply_tier(Tier:int) -> void:
	super(Tier)
	match Tier:
		0:
			ADDITIONAL_SPREAD_SHOT_COUNT = 0  # Common White
		1:
			ADDITIONAL_SPREAD_SHOT_COUNT = 0  # Uncommon Green
		2:
			ADDITIONAL_SPREAD_SHOT_COUNT = 2  # Rare Blue
		3:
			ADDITIONAL_SPREAD_SHOT_COUNT = 3  # Epic Purple
		4:
			ADDITIONAL_SPREAD_SHOT_COUNT = 5  # Legendary Red

func apply_effect(Player:CharacterBody2D):
	if !Effect_applied:
		Player.add_used_spread_shot_count(ADDITIONAL_SPREAD_SHOT_COUNT)
		Effect_applied = true

func remove_effect(Player:CharacterBody2D):
	Player.add_used_spread_shot_count(-ADDITIONAL_SPREAD_SHOT_COUNT)
	Effect_applied = false
