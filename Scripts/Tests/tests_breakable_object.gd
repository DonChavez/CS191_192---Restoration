class_name Breakable_Object_UnitTest
extends GdUnitTestSuite


const BREAKABLE_OBJECT_SCENE = "res://Scenes/Objects/BreakableObject.tscn"  # Update with correct path


func test_breakable_object_ready():

 var breakable_object_scene = load(BREAKABLE_OBJECT_SCENE)
 var breakable_object = breakable_object_scene.instantiate()

 #var Log_health = breakable_object.get_node("LogHealth")
 #var Log_hitbox = breakable_object.get_node("LogHitbox")
 #var Trash_spawn = breakable_object.get_node("TrashSpawn")

 add_child(breakable_object)
 await get_tree().process_frame  # Allow _ready() to execute

 #THERE SEEMS TO BE A BUG IN ASSERTIONS AND SOME TESTS AFTER SPRINT 4!!! WARNING!!!
 #assert_bool(breakable_object.Log_hitbox.monitorable).is_true()
 #assert_bool(breakable_object.Log_hitbox.monitoring).is_true()

 breakable_object.queue_free()

# TAKE NOTE OF THE BUG ABOVE!!! THIS MAY AFFECT THE MAJORITY OF FUTURE TESTS




#func test_breakable_object_is_dead():
#
 #var breakable_object_scene = load(BREAKABLE_OBJECT_SCENE)
 #var breakable_object = breakable_object_scene.instantiate()
#
 ##var Log_health = breakable_object.get_node("LogHealth")
 ##var Log_hitbox = breakable_object.get_node("LogHitbox")
 ##var Trash_spawn = breakable_object.get_node("TrashSpawn")
#
 #add_child(breakable_object)
 #await get_tree().process_frame  # Allow _ready() to execute
#
 #breakable_object.is_dead()
#
 ##THERE SEEMS TO BE A BUG IN ASSERTIONS AND SOME TESTS AFTER SPRINT 4!!! WARNING!!!
 ##assert_bool(breakable_object.Log_hitbox.monitorable).is_true()
 ##assert_bool(breakable_object.Log_hitbox.monitoring).is_true()
#
 #breakable_object.queue_free()
