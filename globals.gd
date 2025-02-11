extends Node

var player_health: float = 100
var player_max_health: float = 100

func save_health(value: float):
	player_health = clamp(value, 0, player_max_health)

func set_max_health(value: float):
	player_max_health = value  # Update max health dynamically
	player_health = min(player_health, player_max_health)  # Prevent overheal

func reset_health():
	player_health = player_max_health
