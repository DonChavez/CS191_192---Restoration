class_name NPC_UnitTest
extends GdUnitTestSuite


const NPC_SCENE = "res://Scenes/Interactables/NPC.tscn"  # Update with correct path


func test_npc_ready():

 var npc_scene = load(NPC_SCENE)
 var npc = npc_scene.instantiate()

 var Sprite = npc.get_node("AnimatedSprite2D")
 var Dialogue = npc.get_node("Dialogue")
 var Guide = npc.get_node("Label")

 add_child(npc)
 await get_tree().process_frame  # Allow _ready() to execute

 assert_bool(npc.can_interact).is_false()
 assert_bool(npc.Dialogue.visible).is_false()
 assert_bool(npc.Guide.visible).is_false()

 npc.queue_free()

func test_npc_enter_area():

 var npc_scene = load(NPC_SCENE)
 var npc = npc_scene.instantiate()

 var Sprite = npc.get_node("AnimatedSprite2D")
 var Dialogue = npc.get_node("Dialogue")
 var Guide = npc.get_node("Label")

 var sample_body = Node2D.new()

 add_child(npc)
 await get_tree().process_frame  # Allow _ready() to execute

 npc._on_area_2d_body_entered(sample_body)

 # Might be limitation, but it should return false
 assert_bool(npc.can_interact).is_false()
 assert_bool(npc.Guide.visible).is_false()

 npc.queue_free()
 sample_body.queue_free()

func test_npc_exit_area():

 var npc_scene = load(NPC_SCENE)
 var npc = npc_scene.instantiate()

 var Sprite = npc.get_node("AnimatedSprite2D")
 var Dialogue = npc.get_node("Dialogue")
 var Guide = npc.get_node("Label")

 var sample_body = Node2D.new()

 add_child(npc)
 await get_tree().process_frame  # Allow _ready() to execute

 npc._on_area_2d_body_entered(sample_body)

 assert_bool(npc.can_interact).is_false()
 assert_bool(npc.Dialogue.visible).is_false()
 assert_bool(npc.Guide.visible).is_false()

 npc.queue_free()
 sample_body.queue_free()
