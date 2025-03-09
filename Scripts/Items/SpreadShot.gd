extends ItemObject

const ADDITIONAL_SPREAD_SHOT_COUNT = 2

func apply_effect(player):
	if !Effect_applied:
		player.Spread_shot_count += ADDITIONAL_SPREAD_SHOT_COUNT
		Effect_applied = true

func remove_effect(player):
	player.Spread_shot_count -= ADDITIONAL_SPREAD_SHOT_COUNT
	Effect_applied = false
