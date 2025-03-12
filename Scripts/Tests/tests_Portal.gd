class_name Portal_UnitTest
extends GdUnitTestSuite

const PORTAL_SCENE = "res://Scenes/Interactables/Portal.tscn"  # Update with correct path

func test_portal_ready():

 var portal_scene = load(PORTAL_SCENE)
 var portal = portal_scene.instantiate()


 var Prompt_label = portal.get_node("Label")
 var Animated_sprite = portal.get_node("Sprite2D")

 add_child(portal)
 await get_tree().process_frame  # Allow _ready() to execute

 assert_bool(portal.Prompt_label.visible).is_false()

 portal.queue_free()

func test_portal_interact():

 var portal_scene = load(PORTAL_SCENE)
 var portal = portal_scene.instantiate()


 var Prompt_label = portal.get_node("Label")
 var Animated_sprite = portal.get_node("Sprite2D")

 add_child(portal)
 await get_tree().process_frame  # Allow _ready() to execute

 # Assertions not needed on interact, Level manager does the changes

 portal.queue_free()

func test_portal_body_enter():

 var portal_scene = load(PORTAL_SCENE)
 var portal = portal_scene.instantiate()


 var Prompt_label = portal.get_node("Label")
 var Animated_sprite = portal.get_node("Sprite2D")

 var sample_body = Node.new()

 add_child(portal)
 await get_tree().process_frame  # Allow _ready() to execute

 portal._on_body_entered(sample_body)
 assert_bool(portal.Player_nearby).is_true()
 assert_bool(portal.Prompt_label.visible).is_true()

 portal.queue_free()
 sample_body.queue_free()

func test_portal_body_exit():

 var portal_scene = load(PORTAL_SCENE)
 var portal = portal_scene.instantiate()


 var Prompt_label = portal.get_node("Label")
 var Animated_sprite = portal.get_node("Sprite2D")

 var sample_body_1 = Node.new()
 var sample_body_2 = Node2D.new()

 add_child(portal)
 await get_tree().process_frame  # Allow _ready() to execute

 portal._on_body_entered(sample_body_1)
 portal._on_body_exited(sample_body_2)
 assert_bool(portal.Player_nearby).is_false()
 assert_bool(portal.Prompt_label.visible).is_false()

 portal.queue_free()
 sample_body_1.queue_free()
 sample_body_2.queue_free()





# Live action process cannot be tested(Ex: _process)
