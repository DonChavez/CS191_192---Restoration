class_name Item_UnitTest
extends GdUnitTestSuite


const ITEM_SCENE = "res://Scenes/Items/0MultiShot.tscn"  # Update with correct path

func test_item_ready():

 var item_scene = load(ITEM_SCENE)
 var item = item_scene.instantiate()

 var Input_label = item.get_node("InputLabel")

 add_child(item)
 await get_tree().process_frame  # Allow _ready() to execute

 assert_bool(item.Input_label.visible).is_false()

 item.queue_free()

#func test_elite_enter_area():
#
 #var item_scene = load(ITEM_SCENE)
 #var item = item_scene.instantiate()
#
 #var Input_label = item.get_node("InputLabel")
#
 #var sample_body = Node2D.new()
#
 #add_child(item)
 #await get_tree().process_frame  # Allow _ready() to execute
#
 ##item._on_area_2d_body_entered(sample_body)
 ##assert_bool(item.Input_label.visible).is_false()
#
 #item.queue_free()

# Cannot test live methods, only BDD or Scene Runner can verify (Ex: _process)
# ++ All other functions below (_on_area_2d_body_entered)
