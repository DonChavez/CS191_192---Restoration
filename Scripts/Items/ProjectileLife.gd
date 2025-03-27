extends ItemObject

@onready var ADDITIONAL_LIFE_COUNT: int


func _ready() -> void:
	super()
	apply_tier(Item_tier)
	Title = Tier_to_text[Item_tier]+" "+Item_name
	Description = "Projectiles exists for an additional "+str(ADDITIONAL_LIFE_COUNT)+" seconds"


func apply_tier(Tier:int) -> void:
	super(Tier)
	match Tier:
		0:
			ADDITIONAL_LIFE_COUNT = 1  # Common White
		1:
			ADDITIONAL_LIFE_COUNT = 2  # Uncommon Green
		2:
			ADDITIONAL_LIFE_COUNT = 3  # Rare Blue
		3:
			ADDITIONAL_LIFE_COUNT = 4  # Epic Purple
		4:
			ADDITIONAL_LIFE_COUNT = 5  # Legendary Red

func apply_effect(player):
	if !Effect_applied:
		player.Live_time_addition += ADDITIONAL_LIFE_COUNT
		Effect_applied = true

func remove_effect(player):
	player.Live_time_addition -= ADDITIONAL_LIFE_COUNT
	Effect_applied = false
