extends ItemObject

@onready var ADDITIONAL_BOUNCE_COUNT: int


func _ready() -> void:
	super()
	apply_tier(Item_tier)
	Title = Tier_to_text[Item_tier]+" "+Item_name
	Description = "Projectiles bounces off of objects "+str(ADDITIONAL_BOUNCE_COUNT)+" time"

func apply_tier(Tier:int) -> void:
	super(Tier)
	match Tier:
		0:
			ADDITIONAL_BOUNCE_COUNT = 1  # Common White
		1:
			ADDITIONAL_BOUNCE_COUNT = 2  # Uncommon Green
		2:
			ADDITIONAL_BOUNCE_COUNT = 3  # Rare Blue
		3:
			ADDITIONAL_BOUNCE_COUNT = 4  # Epic Purple
		4:
			ADDITIONAL_BOUNCE_COUNT = 5  # Legendary Red

func apply_effect(player):
	if !Effect_applied:
		player.Projectile_bounce_count += ADDITIONAL_BOUNCE_COUNT
		Effect_applied = true

func remove_effect(player):
	player.Projectile_bounce_count -= ADDITIONAL_BOUNCE_COUNT
	Effect_applied = false
