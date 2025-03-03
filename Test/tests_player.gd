extends GdUnitTestSuite

const PLAYER_SCENE = "res://Scenes/Player.tscn" # Update with correct path

func test_player_ready():
 #Load and Instantiate Player Scene
 var player_scene = load(PLAYER_SCENE)
 var player = player_scene.instantiate()

 add_child(player)
 await get_tree().process_frame  # Allow _ready() to execute
	
 assert_bool(player.health_component.is_invulnerable).is_false()
 assert_str(player.sprite.animation).is_equal("idle_right")
	
 # Cleanup
 player.queue_free()


#UNFINISHED, WILL DO OTHER SHORTER SCRIPTS FIRST
