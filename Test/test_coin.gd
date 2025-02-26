class_name coin_UnitTest
extends GdUnitTestSuite

const COIN_SCENE = "res://Scenes/Coin.tscn" # Update with correct path
const PLAYER_SCENE = "res://Scenes/Player.tscn" # Update with correct path
const INVENTORY_SCENE = "res://Scenes/Inventory_Manager.tscn"

func test_coin_ready():

 var coin_scene = load(COIN_SCENE)
 #var player_scene = load(PLAYER_SCENE)
 #var inventory_scene = load(INVENTORY_SCENE)

 #var animated_coin : Node = $AnimatedCoin2D.new()
 #animated_coin.name = "AnimatedCoin2D"

 var coin = coin_scene.instantiate()
 #var player = player_scene.instantiate()
 #var inventory = inventory_scene.instantiate()


 add_child(coin)
 await get_tree().process_frame  # Allow _ready() to execute

 assert_float(coin.Speed).is_equal(120)

 coin.queue_free()


# INITIALIZATION/SPAWNING CAN BE TESTED
# LIVE ON_ACTIVITY METHODS(EX: Inventory Manager, _process methods) CANNOT BE TESTED


#func test_coin_enter_body():
#
 #var coin_scene = load(COIN_SCENE)
 ##var player_scene = load(PLAYER_SCENE)
 ##var inventory_scene = load(INVENTORY_SCENE)
#
 #var sample_player = CharacterBody2D.new()
 #var sample_body = CharacterBody2D.new()
#
 ##var animated_coin : Node = $AnimatedCoin2D.new()
 ##animated_coin.name = "AnimatedCoin2D"
#
 #
#
 #var coin = coin_scene.instantiate()
 ##var player = player_scene.instantiate()
 ##var inventory = inventory_scene.instantiate()
#
 ##coin.Player = sample_player
 ##sample_body = sample_player
#
 #add_child(coin)
 #await get_tree().process_frame  # Allow _ready() to execute
#
 #sample_body = sample_player
 ##coin._on_body_entered(sample_body)
#
 ##assert_bool(coin.Player == sample_body).is_true()
#
 #coin.queue_free()
 #sample_player.queue_free()
 #sample_body.queue_free()
