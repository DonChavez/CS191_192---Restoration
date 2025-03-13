class_name shield_UnitTest
extends GdUnitTestSuite

const SHIELD_SCENE = "res://Scenes/Templates/Shield.tscn" # Update with correct path

func test_shield_ready():
 #Load and Instantiate Scene
 var shield_scene = load(SHIELD_SCENE)
 var shield = shield_scene.instantiate()
 var shield_spy = spy(shield)

 var sprite = Sprite2D.new()
 var collision_shape = CollisionShape2D.new()

 sprite.name = "Sprite2D"
 collision_shape.name = "CollisionShape2D"

 shield.add_child(sprite)
 shield.add_child(collision_shape)

 add_child(shield)
 await get_tree().process_frame  # Allow _ready() to execute

 verify(shield_spy, 1)._ready()
 verify(shield_spy, 1).disable_shield()

func test_shield_disable():
 #Load and Instantiate Scene
 var shield_scene = load(SHIELD_SCENE)
 var shield = shield_scene.instantiate()

 var sprite = Sprite2D.new()
 var collision_shape = CollisionShape2D.new()

 sprite.name = "Sprite2D"
 collision_shape.name = "CollisionShape2D"

 shield.add_child(sprite)
 shield.add_child(collision_shape)

 add_child(shield)
 await get_tree().process_frame  # Allow _ready() to execute

 shield.disable_shield()

 assert_bool(shield.visible).is_false()
 assert_bool(shield.monitoring).is_false()
 #Won't assert color since it can be changed dynamically(if we want)


func test_shield_enable():
 #Load and Instantiate Scene
 var shield_scene = load(SHIELD_SCENE)
 var shield = shield_scene.instantiate()
 var shield_spy = spy(shield)

 var sprite = Sprite2D.new()
 var collision_shape = CollisionShape2D.new()

 sprite.name = "Sprite2D"
 collision_shape.name = "CollisionShape2D"

 shield.add_child(sprite)
 shield.add_child(collision_shape)

 add_child(shield)
 await get_tree().process_frame  # Allow _ready() to execute

 shield.enable_shield()

 #assert_bool(shield.monitoring).is_true()
 assert_bool(shield.visible).is_true()

 #Improve Collision Monitor testing
 await get_tree().create_timer(3.0).timeout

 verify(shield_spy, 2).disable_shield()
 assert_bool(shield.visible).is_false()



 #Won't assert color since it can be changed dynamically(if we want)
