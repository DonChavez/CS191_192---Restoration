class_name Inventory_UnitTest
extends GdUnitTestSuite


const INVENTORY_SCENE = "res://Scenes/Inventory/Inventory.tscn"  # Update with correct path

#func test_elite_enemy_ready():
#
 #var inventory_scene = load(INVENTORY_SCENE)
 #var inventory = inventory_scene.instantiate()
#
 #var Inventory_ui = inventory.get_node("InventoryUI")
 #var Player = inventory.get_node("CharacterBody2D")
 #var Inventory_slots = inventory.get_node("InventoryUI/InventoryPanel/ScrollContainer/CenterContainer/InventoryGrid.get_children()")
#
 #add_child(inventory)
 #await get_tree().process_frame  # Allow _ready() to execute
#
 ## Assertions not needed, initialization does not mutate anything of note
#
 #inventory.queue_free()


# Inventory might not be able to be tested
# Might onbly be able to be verified through BDD or Scene Runner
