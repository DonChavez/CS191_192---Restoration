class_name recycler_UnitTest
extends GdUnitTestSuite

const RECYCLER_SCENE = "res://Scenes/recycler.tscn"  # Update with correct path

func test_recycler_ready():

 var recycler_scene = load(RECYCLER_SCENE)
 var recycler = recycler_scene.instantiate()


 var input_label = recycler.get_node("InputLabel")
 var recycler_ui = recycler.get_node("RecyclerUI")

 add_child(recycler)
 await get_tree().process_frame  # Allow _ready() to execute

 assert_bool(input_label.visible).is_false()
 assert_bool(recycler_ui.visible).is_false()

 recycler.queue_free()

func test_recycler_enter_body():

 var recycler_scene = load(RECYCLER_SCENE)
 var recycler = recycler_scene.instantiate()


 var input_label = recycler.get_node("InputLabel")
 var recycler_ui = recycler.get_node("RecyclerUI")

 add_child(recycler)
 await get_tree().process_frame  # Allow _ready() to execute

 recycler._on_area_2d_body_entered(null)

 assert_bool(input_label.visible).is_true()

 recycler.queue_free()

func test_recycler_exit_body():

 var recycler_scene = load(RECYCLER_SCENE)
 var recycler = recycler_scene.instantiate()


 var input_label = recycler.get_node("InputLabel")
 var recycler_ui = recycler.get_node("RecyclerUI")

 add_child(recycler)
 await get_tree().process_frame  # Allow _ready() to execute

 recycler._on_area_2d_body_entered(null)
 assert_bool(input_label.visible).is_true()

 recycler._on_area_2d_body_exited(null)

 assert_bool(input_label.visible).is_false()
 assert_bool(recycler_ui.visible).is_false()


 recycler.queue_free()

func test_recycler_drop():

 var recycler_scene = load(RECYCLER_SCENE)
 var recycler = recycler_scene.instantiate()

 var sample_item = Node2D.new()


 var input_label = recycler.get_node("InputLabel")
 var recycler_ui = recycler.get_node("RecyclerUI")

 add_child(recycler)
 await get_tree().process_frame  # Allow _ready() to execute

 recycler.drop_item(sample_item)
 assert_bool(sample_item.visible).is_true()

 recycler.queue_free()



# Can't test live process(_process, _on_item_slot_clicked)





# Autoloader test experiment to enable %Variable testing
# Not yet Functional

#func test_recycler_ready():
 #var recycler_scene = load(RECYCLER_SCENE)
 #var recycler = recycler_scene.instantiate()
#
 #add_child(recycler)
 #await get_tree().process_frame  # Allow _ready() to execute
#
 #var inventory_manager = get_node_or_null("res://Scripts/inventory_manager.gd")
 #var item_manager = get_node_or_null("res://Scripts/item_manager.gd")
#
 #assert_bool(inventory_manager != null).is_true()
 #assert_bool(item_manager != null).is_true()
#
 #var recycler_ui = recycler.get_node_or_null("RecyclerUI")
 #var recycler_grid = recycler.get_node_or_null("RecyclerGrid")
#
#
 #var recycler_slots = []
 #if recycler_grid:
  #recycler_slots = recycler_grid.get_children()
#
#
 #assert_bool(recycler_ui.visible).is_false()
 #assert_bool(recycler.get_node("InputLabel").visible).is_false()
#
 #recycler.queue_free()
