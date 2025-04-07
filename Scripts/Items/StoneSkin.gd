extends ItemObject

@onready var DAMAGE_REDUCTION_VALUE: int


func _ready() -> void:
	super()
	apply_tier(Item_tier)
	Title = Tier_to_text[Item_tier]+" "+Item_name
	Description = "Reduce incoming damage by "+str(DAMAGE_REDUCTION_VALUE)+"%."
	if Stacking:
		Description += " (Stacks)"
	else:
		Description += " (Does not stack)"

func apply_tier(Tier:int) -> void:
	super(Tier)
	match Tier:
		0:
			DAMAGE_REDUCTION_VALUE = 1  # Common White
		1:
			DAMAGE_REDUCTION_VALUE = 2  # Uncommon Green
		2:
			DAMAGE_REDUCTION_VALUE = 3  # Rare Blue
		3:
			DAMAGE_REDUCTION_VALUE = 4  # Epic Purple
		4:
			DAMAGE_REDUCTION_VALUE = 5  # Legendary Red

func apply_effect(Player:CharacterBody2D):
	if !Effect_applied:
		Player.add_used_damage_reduction_percent(DAMAGE_REDUCTION_VALUE)
		Effect_applied = true

func remove_effect(Player:CharacterBody2D):
	Player.add_used_damage_reduction_percent(-DAMAGE_REDUCTION_VALUE)
	Effect_applied = false
