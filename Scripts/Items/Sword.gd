extends ItemObject

func _ready() -> void:
	super()
	apply_tier(Item_tier)
	Title = Tier_to_text[Item_tier]+" "+Item_name
	Description = "Basic Sword."
	if Stacking:
		Description += " (Stacks)"
	else:
		Description += " (Does not stack)"
func apply_tier(Tier:int) -> void:
	match Tier:
		0: # Common White
			Icon.texture = load("res://Art/Items/Sword.png")
		1: # Uncommon Green
			Icon.texture = load("res://Art/Items/Sword.png")
		2: # Rare Blue
			Icon.texture = load("res://Art/Items/Sword.png")
		3: # Epic Purple
			Icon.texture = load("res://Art/Items/Sword.png")
		4: # Legendary Red
			Icon.texture = load("res://Art/Items/Sword.png")

func apply_effect(Player:CharacterBody2D):
	if !Effect_applied:
		Effect_applied = true

func remove_effect(Player:CharacterBody2D):
	Effect_applied = false
