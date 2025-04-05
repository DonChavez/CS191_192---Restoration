extends ItemObject

@onready var MELEE_X_ADDITIONAL: int
@onready var MELEE_Y_ADDITIONAL: int


func _ready() -> void:
	super()
	apply_tier(Item_tier)
	Title = Tier_to_text[Item_tier]+" "+Item_name
	Description = "Increase Sword length by ("+str(MELEE_X_ADDITIONAL) +", "+ str(MELEE_Y_ADDITIONAL)+")"
	Stacking = false
func apply_tier(Tier:int) -> void:
	super(Tier)
	match Tier:
		0:
			MELEE_X_ADDITIONAL = 10  # Common White
			MELEE_Y_ADDITIONAL = 0
		1:
			MELEE_X_ADDITIONAL = 15
			MELEE_Y_ADDITIONAL = 0  # Uncommon Green
		2:
			MELEE_X_ADDITIONAL = 20
			MELEE_Y_ADDITIONAL = 0  # Rare Blue
		3:
			MELEE_X_ADDITIONAL = 25 
			MELEE_Y_ADDITIONAL = 10  # Epic Purple
		4:
			MELEE_X_ADDITIONAL = 25 
			MELEE_Y_ADDITIONAL = 20  # Legendary Red

func apply_effect(Player:CharacterBody2D):
	if !Effect_applied:
		Player.apply_melee_weapon(MELEE_X_ADDITIONAL, MELEE_Y_ADDITIONAL, Item_name, 1)
		Effect_applied = true

func remove_effect(Player:CharacterBody2D):
	Player.apply_melee_weapon(-MELEE_X_ADDITIONAL, -MELEE_Y_ADDITIONAL, Item_name, -1)
	Effect_applied = false
