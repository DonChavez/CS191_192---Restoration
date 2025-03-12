class_name portal_UnitTest
extends GdUnitTestSuite

const PORTAL_SCENE = "res://Scenes/Templates/Portal.tscn" # Update with correct path


func test_portal_ready():
 #Load and Instantiate Scene
 var portal_scene = load(PORTAL_SCENE)
 var portal = portal_scene.instantiate()
 var portal_spy = spy(portal)

 var prompt_label = Label.new()
 var animated_sprite = Sprite2D.new()
 

 prompt_label.name = "Label"
 animated_sprite.name = "Sprite2D"

 portal.add_child(prompt_label)
 portal.add_child(animated_sprite)

 add_child(portal)
 await get_tree().process_frame  # Allow _ready() to execute

 verify(portal_spy, 1)._ready()
 assert_bool(portal.prompt_label.visible).is_false()
 #Will not assert target_level_path since it will be adaptive(Unless I-hardcode natin)

func test_portal_entered_vicinity():
 #Load and Instantiate Scene
 var portal_scene = load(PORTAL_SCENE)
 var portal = portal_scene.instantiate()

 var prompt_label = Label.new()
 var animated_sprite = Sprite2D.new()
 var sample_object = Node.new()
 
 prompt_label.name = "Label"
 animated_sprite.name = "Sprite2D"

 portal.add_child(prompt_label)
 portal.add_child(animated_sprite)

 add_child(portal)
 await get_tree().process_frame  # Allow _ready() to execute

 portal._on_body_entered(sample_object)

 assert_bool(portal.player_nearby).is_true()
 assert_bool(portal.prompt_label.visible).is_true()

 sample_object.queue_free()

func test_portal_exited_vicinity():
 #Load and Instantiate Scene
 var portal_scene = load(PORTAL_SCENE)
 var portal = portal_scene.instantiate()

 var prompt_label = Label.new()
 var animated_sprite = Sprite2D.new()
 var sample_object = Node.new()
 
 prompt_label.name = "Label"
 animated_sprite.name = "Sprite2D"

 portal.add_child(prompt_label)
 portal.add_child(animated_sprite)

 add_child(portal)
 await get_tree().process_frame  # Allow _ready() to execute

 portal._on_body_entered(sample_object)

 assert_bool(portal.player_nearby).is_true()
 assert_bool(portal.prompt_label.visible).is_true()

 sample_object.queue_free()


#Will not test interact, same reason as target_level_path
