extends ItemObject

@onready var BONUS_DAMAGE: float
@onready var APPLIED_TIME: float

func _ready() -> void:
	super()
	apply_tier(Item_tier)
	Title = Tier_to_text[Item_tier]+" "+Item_name
	Description = "Upon a successful parry, increase melee damage by "+str(BONUS_DAMAGE)+"% for "+str(APPLIED_TIME)+" seconds."
	if Stacking:
		Description += " (Stacks)"
	else:
		Description += " (Does not stack)"

func apply_tier(Tier:int) -> void:
	super(Tier)
	match Tier:
		0:
			BONUS_DAMAGE = 10
			APPLIED_TIME = 0.5  # Common White
			Icon.texture = load("res://Art/Items/riposte_1.png")
		1:
			BONUS_DAMAGE = 20
			APPLIED_TIME = 1  # Uncommon Green
			Icon.texture = load("res://Art/Items/riposte_2.png")
		2:
			BONUS_DAMAGE = 30
			APPLIED_TIME = 1  # Rare Blue
			Icon.texture = load("res://Art/Items/riposte_3.png")
		3:
			BONUS_DAMAGE = 40
			APPLIED_TIME = 1.5  # Epic Purple
			Icon.texture = load("res://Art/Items/riposte_4.png")
		4:
			BONUS_DAMAGE = 50
			APPLIED_TIME = 2  # Legendary Red
			Icon.texture = load("res://Art/Items/riposte_5.png")

func apply_effect(Player:CharacterBody2D):
	if !Effect_applied:
		Player.set_up_timer(Item_ID.substr(1),APPLIED_TIME)
		Player.set_parry_bonus(BONUS_DAMAGE)
		Player.set_parry_bonus_time(APPLIED_TIME)
		Effect_applied = true

func remove_effect(Player:CharacterBody2D):
	Player.set_parry_bonus(0)
	Player.set_parry_bonus_time(0)
	Effect_applied = false
