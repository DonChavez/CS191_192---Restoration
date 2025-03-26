class_name InventoryUI_UnitTest
extends GdUnitTestSuite


const INVENTORY_UI_SCENE = "res://Scenes/Inventory/InventoryUI.tscn"  # Update with correct path

func test_inventory_ui_ready():

 var inventory_ui_scene = load(INVENTORY_UI_SCENE)
 var inventory_ui = inventory_ui_scene.instantiate()

 var Inventory_manager =  inventory_ui.get_node("..")
 var Trashlabel =  inventory_ui.get_node("InventoryPanel/TrashLabel")
 var Coinlabel =  inventory_ui.get_node("InventoryPanel/CoinLabel")
 var Grid =  inventory_ui.get_node("InventoryPanel/ScrollContainer/CenterContainer/InventoryGrid.get_children()")


 add_child(inventory_ui)
 await get_tree().process_frame  # Allow _ready() to execute

 assert_bool(inventory_ui.visible).is_true()                                                                           

 inventory_ui.queue_free()

#func test_inventory_ui_toggle_on():
#
 #var inventory_ui_scene = load(INVENTORY_UI_SCENE)
 #var inventory_ui = inventory_ui_scene.instantiate()
#
 #var Inventory_manager =  inventory_ui.get_node("..")
 #var Trashlabel =  inventory_ui.get_node("InventoryPanel/TrashLabel")
 #var Coinlabel =  inventory_ui.get_node("InventoryPanel/CoinLabel")
 #var Grid =  inventory_ui.get_node("InventoryPanel/ScrollContainer/CenterContainer/InventoryGrid.get_children()")
#
#
 #add_child(inventory_ui)
 #await get_tree().process_frame  # Allow _ready() to execute
#
 #inventory_ui.toggle_inventory()
 #assert_bool(inventory_ui.visible).is_true()                                                                                 
#
 #inventory_ui.queue_free()
#
#func test_inventory_ui_toggle_off():
#
 #var inventory_ui_scene = load(INVENTORY_UI_SCENE)
 #var inventory_ui = inventory_ui_scene.instantiate()
#
 #var Inventory_manager =  inventory_ui.get_node("..")
 #var Trashlabel =  inventory_ui.get_node("InventoryPanel/TrashLabel")
 #var Coinlabel =  inventory_ui.get_node("InventoryPanel/CoinLabel")
 #var Grid =  inventory_ui.get_node("InventoryPanel/ScrollContainer/CenterContainer/InventoryGrid.get_children()")
#
#
 #add_child(inventory_ui)
 #await get_tree().process_frame  # Allow _ready() to execute
#
 #inventory_ui.toggle_inventory()
 #inventory_ui.toggle_inventory()
 #assert_bool(inventory_ui.visible).is_false()                                                                                 
#
 #inventory_ui.queue_free()

func test_inventory_ui_update_trash():

 var inventory_ui_scene = load(INVENTORY_UI_SCENE)
 var inventory_ui = inventory_ui_scene.instantiate()

 var Inventory_manager =  inventory_ui.get_node("..")
 var Trashlabel =  inventory_ui.get_node("InventoryPanel/TrashLabel")
 var Coinlabel =  inventory_ui.get_node("InventoryPanel/CoinLabel")
 var Grid =  inventory_ui.get_node("InventoryPanel/ScrollContainer/CenterContainer/InventoryGrid.get_children()")


 add_child(inventory_ui)
 await get_tree().process_frame  # Allow _ready() to execute

 inventory_ui.update_trash(18)       
 assert_str(inventory_ui.Trashlabel.text).is_equal("18")                                                                         

 inventory_ui.queue_free()

func test_inventory_ui_update_coin():

 var inventory_ui_scene = load(INVENTORY_UI_SCENE)
 var inventory_ui = inventory_ui_scene.instantiate()

 var Inventory_manager =  inventory_ui.get_node("..")
 var Trashlabel =  inventory_ui.get_node("InventoryPanel/TrashLabel")
 var Coinlabel =  inventory_ui.get_node("InventoryPanel/CoinLabel")
 var Grid =  inventory_ui.get_node("InventoryPanel/ScrollContainer/CenterContainer/InventoryGrid.get_children()")


 add_child(inventory_ui)
 await get_tree().process_frame  # Allow _ready() to execute

 inventory_ui.update_coin(21)       
 assert_str(inventory_ui.Coinlabel.text).is_equal("21")                                                                         

 inventory_ui.queue_free()

#func test_inventory_ui_update_inventory():
#
 #var inventory_ui_scene = load(INVENTORY_UI_SCENE)
 #var inventory_ui = inventory_ui_scene.instantiate()
#
 #var Inventory_manager =  inventory_ui.get_node("..")
 #var Trashlabel =  inventory_ui.get_node("InventoryPanel/TrashLabel")
 #var Coinlabel =  inventory_ui.get_node("InventoryPanel/CoinLabel")
 #var Grid =  inventory_ui.get_node("InventoryPanel/ScrollContainer/CenterContainer/InventoryGrid.get_children()")
#
#
 #add_child(inventory_ui)
 #await get_tree().process_frame  # Allow _ready() to execute
#
 #inventory_ui.update_inventory()
 ## Assertions are not needed, no significant updates/mutations done by update inventory to inventory_ui local                                                                                
#
 #inventory_ui.queue_free()


 # Can't test live methods/functions (Might have to be in BDD or Scene Runner)
