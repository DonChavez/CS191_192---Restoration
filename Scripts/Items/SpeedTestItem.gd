extends ItemObject

const ADDITIONAL_SPEED = 100

func apply_effect(player):
	if !Effect_applied:
		player.Move_speed += ADDITIONAL_SPEED
		Effect_applied = true

func remove_effect(player):
	player.Move_speed -= ADDITIONAL_SPEED
	Effect_applied = false
