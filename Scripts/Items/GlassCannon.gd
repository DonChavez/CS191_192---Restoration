extends ItemObject

@onready var DAMAGE_REDUCTION_VALUE: int
@onready var DAMAGE_PERCENT: int


func _ready() -> void:
	super()
	apply_tier(Item_tier)
	Title = Tier_to_text[Item_tier]+" "+Item_name
	Description = "Incrase Range Damage by "+ str(DAMAGE_PERCENT)+"%, Increase Melee Damage by "+str(DAMAGE_PERCENT*2)+"% but killed by a single hit."
	if Stacking:
		Description += " (Stacks)"
	else:
		Description += " (Does not stack)"
	
func apply_tier(Tier:int) -> void:
	super(Tier)
	match Tier:
		0:
			DAMAGE_REDUCTION_VALUE = 0  
			DAMAGE_PERCENT = 0 # Common White
			Icon.texture = load("res://Art/Items/glass_1.png")
		1:
			DAMAGE_REDUCTION_VALUE = 0  
			DAMAGE_PERCENT = 0  # Uncommon Green
			Icon.texture = load("res://Art/Items/glass_2.png")
		2:
			DAMAGE_REDUCTION_VALUE = -10000000000  
			DAMAGE_PERCENT = 50  # Rare Blue
			Icon.texture = load("res://Art/Items/glass_3.png")
		3:
			DAMAGE_REDUCTION_VALUE = -10000000000  
			DAMAGE_PERCENT = 75  # Epic Purple
			Icon.texture = load("res://Art/Items/glass_4.png")
		4:
			DAMAGE_REDUCTION_VALUE = -10000000000 
			DAMAGE_PERCENT = 100  # Legendary Red
			Icon.texture = load("res://Art/Items/glass_5.png")

func apply_effect(Player:CharacterBody2D):
	if !Effect_applied:
		Player.add_used_damage_reduction_percent(DAMAGE_REDUCTION_VALUE)
		Player.add_percent_range_damage(DAMAGE_PERCENT)
		Player.add_percent_melee_damage(DAMAGE_PERCENT*2)
		Effect_applied = true

func remove_effect(Player:CharacterBody2D):
	Player.add_used_damage_reduction_percent(-DAMAGE_REDUCTION_VALUE)
	Player.add_percent_range_damage(DAMAGE_PERCENT)
	Player.add_percent_melee_damage(-DAMAGE_PERCENT*2)
	Effect_applied = false
