extends GdUnitTestSuite

const RECYCLER_SCENE = "res://Scenes/Recycler.tscn"  # Update with correct path










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
