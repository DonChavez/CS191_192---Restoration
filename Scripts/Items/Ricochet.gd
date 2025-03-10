extends ItemObject

const ADDITIONAL_BOUNCE_COUNT = 5

func apply_effect(player):
	if !Effect_applied:
		player.Projectile_bounce_count += ADDITIONAL_BOUNCE_COUNT
		Effect_applied = true

func remove_effect(player):
	player.Projectile_bounce_count -= ADDITIONAL_BOUNCE_COUNT
	Effect_applied = false
