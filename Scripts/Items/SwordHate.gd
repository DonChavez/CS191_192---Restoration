extends ItemObject

@onready var MELEE_DAMAGE_PERCENT: int


func _ready() -> void:
	super()
	apply_tier(Item_tier)
	Title = Tier_to_text[Item_tier]+" "+Item_name
	Description = "Increase Sword Damage by "+str(MELEE_DAMAGE_PERCENT) +"% for every successful successive hit. Reset upon miss."
	if Stacking:
		Description += " (Stacks)"
	else:
		Description += " (Does not stack)"
		
func apply_tier(Tier:int) -> void:
	super(Tier)
	match Tier:
		0:
			MELEE_DAMAGE_PERCENT = 1  # Common White
			Icon.texture = load("res://Art/Items/rage_1.png")
		1:
			MELEE_DAMAGE_PERCENT = 2# Uncommon Green
			Icon.texture = load("res://Art/Items/rage_2.png")
		2:
			MELEE_DAMAGE_PERCENT = 3# Rare Blue
			Icon.texture = load("res://Art/Items/rage_3.png")
		3:
			MELEE_DAMAGE_PERCENT = 4# Epic Purple
			Icon.texture = load("res://Art/Items/rage_4.png")
		4:
			MELEE_DAMAGE_PERCENT = 5# Legendary Red
			Icon.texture = load("res://Art/Items/rage_5.png")

func apply_effect(Player:CharacterBody2D):
	if !Effect_applied:
		Player.apply_melee_weapon(0, 0, Item_name, 1)
		Player.add_percent_hate_damage(MELEE_DAMAGE_PERCENT)
		Effect_applied = true

func remove_effect(Player:CharacterBody2D):
	Player.apply_melee_weapon(0, 0, Item_name, 0)
	Player.add_percent_hate_damage(-MELEE_DAMAGE_PERCENT)
	Effect_applied = false
