extends ItemObject

@onready var MAX_HEALTH_VALUE: int


func _ready() -> void:
	super()
	apply_tier(Item_tier)
	Title = Tier_to_text[Item_tier]+" "+Item_name
	Description = "Increase Max Health by "+str(MAX_HEALTH_VALUE)+"%."
	if Stacking:
		Description += " (Stacks)"
	else:
		Description += " (Does not stack)"

func apply_tier(Tier:int) -> void:
	super(Tier)
	match Tier:
		0:
			MAX_HEALTH_VALUE = 1  # Common White
			Icon.texture = load("res://Art/Items/life_1.png")
		1:
			MAX_HEALTH_VALUE = 2  # Uncommon Green
			Icon.texture = load("res://Art/Items/life_2.png")
		2:
			MAX_HEALTH_VALUE = 3  # Rare Blue
			Icon.texture = load("res://Art/Items/life_3.png")
		3:
			MAX_HEALTH_VALUE = 4  # Epic Purple
			Icon.texture = load("res://Art/Items/life_4.png")
		4:
			MAX_HEALTH_VALUE = 5  # Legendary Red
			Icon.texture = load("res://Art/Items/life_5.png")

func apply_effect(Player:CharacterBody2D):
	if !Effect_applied:
		Player.add_percent_max_health(MAX_HEALTH_VALUE)
		Effect_applied = true

func remove_effect(Player:CharacterBody2D):
	Player.add_percent_max_health(-MAX_HEALTH_VALUE)
	Effect_applied = false
