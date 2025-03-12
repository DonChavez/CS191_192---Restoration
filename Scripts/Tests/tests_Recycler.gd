class_name Recycler_UnitTest
extends GdUnitTestSuite


const RECYCLER_SCENE = "res://Scenes/Interactables/Recycler.tscn"  # Update with correct pathnt.tscn"

func test_recycler_ready():

 var recycler_scene = load(RECYCLER_SCENE)
 var recycler = recycler_scene.instantiate()

 var Input_label = recycler.get_node("InputLabel")
 var RecyclerUI = recycler.get_node("RecyclerUI")
 var Item_manager = recycler.get_node("ItemManager")
 var Recycler_slots1 = recycler.get_node("$RecyclerUI/RecyclerPanel/CenterContainer/RecyclerGrid.get_children()")
 var Recycler_slots2 = recycler.get_node("RecyclerUI/RecyclerPanel/CenterContainer2/RecyclerGrid2.get_children()")

 add_child(recycler)
 await get_tree().process_frame  # Allow _ready() to execute

 assert_bool(recycler.Input_label.visible).is_false()
 assert_bool(recycler.RecyclerUI.visible).is_false()

 recycler.queue_free()

#func test_recycler_enter_body():
#
 #var recycler_scene = load(RECYCLER_SCENE)
 #var recycler = recycler_scene.instantiate()
#
 #var Input_label = recycler.get_node("InputLabel")
 #var RecyclerUI = recycler.get_node("RecyclerUI")
 #var Item_manager = recycler.get_node("ItemManager")
 #var Recycler_slots1 = recycler.get_node("$RecyclerUI/RecyclerPanel/CenterContainer/RecyclerGrid.get_children()")
 #var Recycler_slots2 = recycler.get_node("RecyclerUI/RecyclerPanel/CenterContainer2/RecyclerGrid2.get_children()")
#
 #var sample_body = Node2D.new()
#
 #add_child(recycler)
 #await get_tree().process_frame  # Allow _ready() to execute
#
 ##recycler._on_area_2d_body_entered(sample_body)
 ##assert_bool(recycler.Input_label.visible).is_true()
#
 ## Potential error on Node2D != CharacterBody2D 
#
 #recycler.queue_free()
 #sample_body.queue_free()
#
#func test_recycler_exit_body():
#
 #var recycler_scene = load(RECYCLER_SCENE)
 #var recycler = recycler_scene.instantiate()
#
 #var Input_label = recycler.get_node("InputLabel")
 #var RecyclerUI = recycler.get_node("RecyclerUI")
 #var Item_manager = recycler.get_node("ItemManager")
 #var Recycler_slots1 = recycler.get_node("$RecyclerUI/RecyclerPanel/CenterContainer/RecyclerGrid.get_children()")
 #var Recycler_slots2 = recycler.get_node("RecyclerUI/RecyclerPanel/CenterContainer2/RecyclerGrid2.get_children()")
#
 #var sample_body = Node2D.new()
#
 #add_child(recycler)
 #await get_tree().process_frame  # Allow _ready() to execute
#
 ##recycler._on_area_2d_body_exited(sample_body)
 ##assert_bool(recycler.Input_label.visible).is_false()
 ##assert_bool(recycler.RecyclerUI.visible).is_false()
#
#
 #recycler.queue_free()
 #sample_body.queue_free()





#func test_recycler_drop_item():
#
 #var recycler_scene = load(RECYCLER_SCENE)
 #var recycler = recycler_scene.instantiate()
#
 #var Input_label = recycler.get_node("InputLabel")
 #var RecyclerUI = recycler.get_node("RecyclerUI")
 #var Item_manager = recycler.get_node("ItemManager")
 #var Recycler_slots1 = recycler.get_node("$RecyclerUI/RecyclerPanel/CenterContainer/RecyclerGrid.get_children()")
 #var Recycler_slots2 = recycler.get_node("RecyclerUI/RecyclerPanel/CenterContainer2/RecyclerGrid2.get_children()")
#
 #var sample_item = Node2D.new()
#
 #add_child(recycler)
 #await get_tree().process_frame  # Allow _ready() to execute
#
 #recycler.drop_item(sample_item)
 #assert_bool(recycler.Item_instance.visible).is_true()
#
 #recycler.queue_free()
 #sample_item.queue_free()


# Can't test Live processes (Ex: _process)
# ++ (Drop_item)
# ++ (_on_recycler_button_clicked)
# If have time: Take into account Player Manager in Recycler
