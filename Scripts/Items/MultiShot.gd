extends ItemObject

@onready var ADDITIONAL_SHOT_COUNT: int


func _ready() -> void:
	super()
	apply_tier(Item_tier)
	Title = Tier_to_text[Item_tier]+" "+Item_name
	Description = "Upon shooting projectiles, shoots an additional "+str(ADDITIONAL_SHOT_COUNT)+" time"


func apply_tier(Tier:int) -> void:
	super(Tier)
	match Tier:
		0:
			ADDITIONAL_SHOT_COUNT = 0  # Common White
		1:
			ADDITIONAL_SHOT_COUNT = 0  # Uncommon Green
		2:
			ADDITIONAL_SHOT_COUNT = 1  # Rare Blue
		3:
			ADDITIONAL_SHOT_COUNT = 2  # Epic Purple
		4:
			ADDITIONAL_SHOT_COUNT = 3  # Legendary Red

func apply_effect(Player:CharacterBody2D):
	if !Effect_applied:
		Player.Multi_shot_count += ADDITIONAL_SHOT_COUNT
		Effect_applied = true

func remove_effect(Player:CharacterBody2D):
	Player.Multi_shot_count -= ADDITIONAL_SHOT_COUNT
	Effect_applied = false
