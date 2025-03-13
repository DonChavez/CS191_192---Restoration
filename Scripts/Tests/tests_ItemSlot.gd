class_name ItemSlot_UnitTest
extends GdUnitTestSuite


const ITEM_SLOT_SCENE = "res://Scenes/Inventory/ItemSlot.tscn"  # Update with correct path

func test_item_slot_ready():

 var item_slot_scene = load(ITEM_SLOT_SCENE)
 var item_slot = item_slot_scene.instantiate()

 var The_label = item_slot.get_node("CenterContainer/Label")

 add_child(item_slot)
 await get_tree().process_frame  # Allow _ready() to execute

 # Assertions not needed, initialization does not mutate anything of note

 item_slot.queue_free()

func test_item_slot_toggle_item_obtain():

 var item_slot_scene = load(ITEM_SLOT_SCENE)
 var item_slot = item_slot_scene.instantiate()

 var The_label = item_slot.get_node("CenterContainer/Label")

 add_child(item_slot)
 await get_tree().process_frame  # Allow _ready() to execute

 item_slot.toggle_item()
 assert_bool(item_slot.Has_item).is_true()

 item_slot.queue_free()

func test_item_slot_toggle_item_discard():

 var item_slot_scene = load(ITEM_SLOT_SCENE)
 var item_slot = item_slot_scene.instantiate()

 var The_label = item_slot.get_node("CenterContainer/Label")

 add_child(item_slot)
 await get_tree().process_frame  # Allow _ready() to execute

 item_slot.toggle_item()
 item_slot.toggle_item()
 assert_bool(item_slot.Has_item).is_false()

 item_slot.queue_free()

func test_item_slot_click_no_item():

 var item_slot_scene = load(ITEM_SLOT_SCENE)
 var item_slot = item_slot_scene.instantiate()

 var The_label = item_slot.get_node("CenterContainer/Label")

 add_child(item_slot)
 await get_tree().process_frame  # Allow _ready() to execute

 item_slot._on_pressed()
 assert_bool(item_slot.Clicked).is_false()

 item_slot.queue_free()

func test_item_slot_click_has_item():

 var item_slot_scene = load(ITEM_SLOT_SCENE)
 var item_slot = item_slot_scene.instantiate()

 var The_label = item_slot.get_node("CenterContainer/Label")

 add_child(item_slot)
 await get_tree().process_frame  # Allow _ready() to execute

 item_slot.toggle_item()
 item_slot._on_pressed()
 assert_bool(item_slot.Clicked).is_true()

 item_slot.queue_free()

func test_item_slot_reset():

 var item_slot_scene = load(ITEM_SLOT_SCENE)
 var item_slot = item_slot_scene.instantiate()

 var The_label = item_slot.get_node("CenterContainer/Label")

 add_child(item_slot)
 await get_tree().process_frame  # Allow _ready() to execute

 item_slot.toggle_item()
 item_slot._on_pressed()
 item_slot.reset()
 assert_bool(item_slot.Clicked).is_false()

 item_slot.queue_free()

func test_item_set_index():

 var item_slot_scene = load(ITEM_SLOT_SCENE)
 var item_slot = item_slot_scene.instantiate()

 var The_label = item_slot.get_node("CenterContainer/Label")

 add_child(item_slot)
 await get_tree().process_frame  # Allow _ready() to execute

 item_slot.set_index(4)
 assert_int(item_slot.Array_indx).is_equal(4)

 item_slot.queue_free()

func test_item_change_label():

 var item_slot_scene = load(ITEM_SLOT_SCENE)
 var item_slot = item_slot_scene.instantiate()

 var The_label = item_slot.get_node("CenterContainer/Label")

 add_child(item_slot)
 await get_tree().process_frame  # Allow _ready() to execute

 item_slot.change_label("Glimpse of Flames")
 assert_str(item_slot.The_label.text).is_equal("Glimpse of Flames")

 item_slot.queue_free()


# Cannot test live methods (For BDD or Scene runner) [Ex: _on_mouse_entered etc...]
