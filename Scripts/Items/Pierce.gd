extends ItemObject

@onready var ADDITIONAL_PIERCE_COUNT: int


func _ready() -> void:
	super()
	apply_tier(Item_tier)
	Title = Tier_to_text[Item_tier]+" "+Item_name
	Description = "Projectiles passes through "+str(ADDITIONAL_PIERCE_COUNT)+" Enemies"

func apply_tier(Tier:int) -> void:
	super(Tier)
	match Tier:
		0:
			ADDITIONAL_PIERCE_COUNT = 0  # Common White
		1:
			ADDITIONAL_PIERCE_COUNT = 1  # Uncommon Green
		2:
			ADDITIONAL_PIERCE_COUNT = 2  # Rare Blue
		3:
			ADDITIONAL_PIERCE_COUNT = 3  # Epic Purple
		4:
			ADDITIONAL_PIERCE_COUNT = 4  # Legendary Red

func apply_effect(Player:CharacterBody2D):
	if !Effect_applied:
		Player.add_used_pierce_addition(ADDITIONAL_PIERCE_COUNT)
		Effect_applied = true

func remove_effect(Player:CharacterBody2D):
	Player.add_used_pierce_addition(-ADDITIONAL_PIERCE_COUNT)
	Effect_applied = false
