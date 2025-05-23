extends ItemObject

@onready var ADDITIONAL_SHOT_COUNT: int


func _ready() -> void:
	super()
	apply_tier(Item_tier)
	Title = Tier_to_text[Item_tier]+" "+Item_name
	Description = "Upon shooting projectiles, shoots an additional "+str(ADDITIONAL_SHOT_COUNT)+" time."
	if Stacking:
		Description += " (Stacks)"
	else:
		Description += " (Does not stack)"
		
func apply_tier(Tier:int) -> void:
	super(Tier)
	match Tier:
		0:
			ADDITIONAL_SHOT_COUNT = 0  # Common White
			Icon.texture = load("res://Art/Items/multi_1.png")
		1:
			ADDITIONAL_SHOT_COUNT = 0  # Uncommon Green
			Icon.texture = load("res://Art/Items/multi_2.png")
		2:
			ADDITIONAL_SHOT_COUNT = 1  # Rare Blue
			Icon.texture = load("res://Art/Items/multi_3.png")
		3:
			ADDITIONAL_SHOT_COUNT = 2  # Epic Purple
			Icon.texture = load("res://Art/Items/multi_4.png")
		4:
			ADDITIONAL_SHOT_COUNT = 3  # Legendary Red
			Icon.texture = load("res://Art/Items/multi_5.png")

func apply_effect(Player:CharacterBody2D):
	if !Effect_applied:
		Player.add_used_multi_shot_count(ADDITIONAL_SHOT_COUNT)
		Effect_applied = true

func remove_effect(Player:CharacterBody2D):
	Player.add_used_multi_shot_count(-ADDITIONAL_SHOT_COUNT)
	Effect_applied = false
