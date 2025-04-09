extends ItemObject

@onready var ADDITIONAL_PIERCE_COUNT: int


func _ready() -> void:
	super()
	apply_tier(Item_tier)
	Title = Tier_to_text[Item_tier]+" "+Item_name
	Description = "Projectiles passes through "+str(ADDITIONAL_PIERCE_COUNT)+" Enemies."
	if Stacking:
		Description += " (Stacks)"
	else:
		Description += " (Does not stack)"
		
func apply_tier(Tier:int) -> void:
	super(Tier)
	match Tier:
		0:
			ADDITIONAL_PIERCE_COUNT = 0  # Common White
			Icon.texture = load("res://Art/Items/pierce_1.png")
		1:
			ADDITIONAL_PIERCE_COUNT = 1  # Uncommon Green
			Icon.texture = load("res://Art/Items/pierce_2.png")
		2:
			ADDITIONAL_PIERCE_COUNT = 2  # Rare Blue
			Icon.texture = load("res://Art/Items/pierce_3.png")
		3:
			ADDITIONAL_PIERCE_COUNT = 3  # Epic Purple
			Icon.texture = load("res://Art/Items/pierce_4.png")
		4:
			ADDITIONAL_PIERCE_COUNT = 4  # Legendary Red
			Icon.texture = load("res://Art/Items/pierce_5.png")

func apply_effect(Player:CharacterBody2D):
	if !Effect_applied:
		Player.add_used_pierce_addition(ADDITIONAL_PIERCE_COUNT)
		Effect_applied = true

func remove_effect(Player:CharacterBody2D):
	Player.add_used_pierce_addition(-ADDITIONAL_PIERCE_COUNT)
	Effect_applied = false
