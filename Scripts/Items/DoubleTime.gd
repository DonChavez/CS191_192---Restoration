extends ItemObject

@onready var MOVEMENT_SPEED_VALUE: int


func _ready() -> void:
	super()
	apply_tier(Item_tier)
	Title = Tier_to_text[Item_tier]+" "+Item_name
	Description = "Increase Movement speed by "+str(MOVEMENT_SPEED_VALUE)+"%."
	if Stacking:
		Description += " (Stacks)"
	else:
		Description += " (Does not stack)"

func apply_tier(Tier:int) -> void:
	super(Tier)
	match Tier:
		0:
			MOVEMENT_SPEED_VALUE = 1  # Common White
		1:
			MOVEMENT_SPEED_VALUE = 2  # Uncommon Green
		2:
			MOVEMENT_SPEED_VALUE = 3  # Rare Blue
		3:
			MOVEMENT_SPEED_VALUE = 4  # Epic Purple
		4:
			MOVEMENT_SPEED_VALUE = 5  # Legendary Red

func apply_effect(Player:CharacterBody2D):
	if !Effect_applied:
		Player.add_percent_movement_speed(MOVEMENT_SPEED_VALUE)
		Effect_applied = true

func remove_effect(Player:CharacterBody2D):
	Player.add_percent_movement_speed(-MOVEMENT_SPEED_VALUE)
	Effect_applied = false
