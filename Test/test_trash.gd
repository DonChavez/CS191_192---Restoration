class_name trash_UnitTest
extends GdUnitTestSuite

const TRASH_SCENE = "res://Scenes/Trash.tscn" # Update with correct path

func test_trash_ready():

 var trash_scene = load(TRASH_SCENE)
 var trash = trash_scene.instantiate()

 add_child(trash)
 await get_tree().process_frame

 trash.queue_free()

func test_trash_enter_body():
 var trash_scene = load(TRASH_SCENE)
 var trash = trash_scene.instantiate()

 add_child(trash)
 await get_tree().process_frame  

 var input_label = trash.get_node("InputLabel")

 trash._on_area_2d_body_entered(null)
 assert_bool(input_label.visible).is_true()

 trash.queue_free()

func test_trash_exit_body():
 var trash_scene = load(TRASH_SCENE)
 var trash = trash_scene.instantiate()

 add_child(trash)
 await get_tree().process_frame  

 var input_label = trash.get_node("InputLabel")

 trash._on_area_2d_body_entered(null)
 assert_bool(input_label.visible).is_true()

 trash._on_area_2d_body_exited(null)
 assert_bool(input_label.visible).is_false()

 trash.queue_free()


#BREAK THROUGH, ABLE TO TEST $VARIABLES with no scene/ Non-Node types
