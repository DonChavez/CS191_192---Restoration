extends ItemObject

@onready var DISAPPEAR_TIME: float


func _ready() -> void:
	super()
	apply_tier(Item_tier)
	Title = Tier_to_text[Item_tier]+" "+Item_name
	Description = "Upon a successful parry, become invisible for "+str(DISAPPEAR_TIME)+" seconds."
	if Stacking:
		Description += " (Stacks)"
	else:
		Description += " (Does not stack)"

func apply_tier(Tier:int) -> void:
	super(Tier)
	match Tier:
		0:
			DISAPPEAR_TIME = 1  # Common White
			Icon.texture = load("res://Art/Items/invincible_1.png")
		1:
			DISAPPEAR_TIME = 1.5  # Uncommon Green
			Icon.texture = load("res://Art/Items/invincible_2.png")
		2:
			DISAPPEAR_TIME = 2  # Rare Blue
			Icon.texture = load("res://Art/Items/invincible_3.png")
		3:
			DISAPPEAR_TIME = 2.5  # Epic Purple
			Icon.texture = load("res://Art/Items/invincible_4.png")
		4:
			DISAPPEAR_TIME = 3  # Legendary Red
			Icon.texture = load("res://Art/Items/invincible_5.png")

func apply_effect(Player:CharacterBody2D):
	if !Effect_applied:
		Player.set_up_timer(Item_ID.substr(1),DISAPPEAR_TIME)
		Player.set_disappear_time(DISAPPEAR_TIME)
		Effect_applied = true

func remove_effect(Player:CharacterBody2D):
	Player.set_disappear_time(0)
	Effect_applied = false
