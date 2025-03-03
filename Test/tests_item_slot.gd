class_name item_slot_UnitTest
extends GdUnitTestSuite

const ITEM_SLOT_SCENE = "res://Scenes/item_slot.tscn"  # Update with correct path

func test_item_slot_ready():

 var item_slot_scene = load(ITEM_SLOT_SCENE)
 var item_slot = item_slot_scene.instantiate()


 var label = item_slot.get_node("CenterContainer/Label")

 add_child(item_slot)
 await get_tree().process_frame  # Allow _ready() to execute

 assert_int(item_slot.Array_indx).is_equal(-1)
 assert_int(item_slot.Row_ID).is_equal(-1)
 assert_bool(item_slot.Hovering).is_false()

 item_slot.queue_free()

func test_item_slot_set_index():

 var item_slot_scene = load(ITEM_SLOT_SCENE)
 var item_slot = item_slot_scene.instantiate()


 var label = item_slot.get_node("CenterContainer/Label")

 add_child(item_slot)
 await get_tree().process_frame  # Allow _ready() to execute

 item_slot.set_index(7)
 assert_int(item_slot.Array_indx).is_equal(7)

 item_slot.queue_free()

func test_item_slot_set_id():

 var item_slot_scene = load(ITEM_SLOT_SCENE)
 var item_slot = item_slot_scene.instantiate()


 var label = item_slot.get_node("CenterContainer/Label")

 add_child(item_slot)
 await get_tree().process_frame  # Allow _ready() to execute

 item_slot.set_id(8)
 assert_int(item_slot.Row_ID).is_equal(8)

 item_slot.queue_free()

func test_item_slot_change_label():

 var item_slot_scene = load(ITEM_SLOT_SCENE)
 var item_slot = item_slot_scene.instantiate()


 var label = item_slot.get_node("CenterContainer/Label")

 add_child(item_slot)
 await get_tree().process_frame  # Allow _ready() to execute

 item_slot.change_label("Lunar Memory")
 assert_str(item_slot.The_label.text).is_equal("Lunar Memory")

 item_slot.queue_free()
