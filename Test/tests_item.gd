class_name item_UnitTest
extends GdUnitTestSuite

const ITEM_SCENE = "res://Scenes/Items/item.tscn"  # Update with correct path

func test_item_ready():

 var item_scene = load(ITEM_SCENE)
 var item = item_scene.instantiate()

 var Input_label = item.get_node("InputLabel")

 add_child(item)
 await get_tree().process_frame  # Allow _ready() to execute

 assert_bool(item.Input_label.visible).is_false()

 item.queue_free()


func test_item_drop():

 var item_scene = load(ITEM_SCENE)
 var item = item_scene.instantiate()

 var Input_label = item.get_node("InputLabel")

 add_child(item)
 await get_tree().process_frame  # Allow _ready() to execute

 item.dropped_item()

 assert_bool(item.Input_label.visible).is_false()

 item.queue_free()


func test_item_enter_body():

 var item_scene = load(ITEM_SCENE)
 var item = item_scene.instantiate()

 var sample_body = Node2D.new()

 var Input_label = item.get_node("InputLabel")

 add_child(item)
 await get_tree().process_frame  # Allow _ready() to execute

 item._on_area_2d_body_entered(sample_body)

 assert_bool(item.Input_label.visible).is_true()

 item.queue_free()
 sample_body.queue_free()


func test_item_exit_body():

 var item_scene = load(ITEM_SCENE)
 var item = item_scene.instantiate()

 var sample_body = Node2D.new()

 var Input_label = item.get_node("InputLabel")

 add_child(item)
 await get_tree().process_frame  # Allow _ready() to execute

 item._on_area_2d_body_entered(sample_body)
 item._on_area_2d_body_exited(sample_body)

 assert_bool(item.Input_label.visible).is_false()

 item.queue_free()
 sample_body.queue_free()







# Issue with Node2D and existence
#func test_item_to_inventory():
#
 #var item_scene = load(ITEM_SCENE)
 #var item = item_scene.instantiate()
#
 #var sample_item = Node2D.new()
#
 #var Input_label = item.get_node("InputLabel")
#
 #add_child(item)
 #await get_tree().process_frame  # Allow _ready() to execute
#
 ##assert_bool(item.Input_label.visible).is_false()
 #item.send_to_inventory(sample_item)
#
 #item.queue_free()
