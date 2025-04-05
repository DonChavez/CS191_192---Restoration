extends ItemObject

@onready var MELEE_LIFESTEAL_PERCENT: int


func _ready() -> void:
	super()
	apply_tier(Item_tier)
	Title = Tier_to_text[Item_tier]+" "+Item_name
	Description = "Add Sword Life Steal "+str(MELEE_LIFESTEAL_PERCENT) +"%."
	if Stacking:
		Description += " (Stacks)"
	else:
		Description += " (Does not stack)"
		
func apply_tier(Tier:int) -> void:
	super(Tier)
	match Tier:
		0:
			MELEE_LIFESTEAL_PERCENT = 1  # Common White
		1:
			MELEE_LIFESTEAL_PERCENT = 2# Uncommon Green
		2:
			MELEE_LIFESTEAL_PERCENT = 3# Rare Blue
		3:
			MELEE_LIFESTEAL_PERCENT = 4# Epic Purple
		4:
			MELEE_LIFESTEAL_PERCENT = 5# Legendary Red

func apply_effect(Player:CharacterBody2D):
	if !Effect_applied:
		print("Applied")
		Player.apply_melee_weapon(0, 0, Item_name, 1)
		Player.add_used_lifesteal_percent(MELEE_LIFESTEAL_PERCENT)
		Effect_applied = true

func remove_effect(Player:CharacterBody2D):
	Player.apply_melee_weapon(0, 0, Item_name, 0)
	Player.add_used_lifesteal_percent(-MELEE_LIFESTEAL_PERCENT)
	Effect_applied = false
