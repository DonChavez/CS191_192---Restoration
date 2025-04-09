class_name Stairs_UnitTest
extends GdUnitTestSuite

const STAIRS_SCENE = "res://Scripts/Tests/Test_Scenes/stairs.tscn"  # Update with correct path


func test_stairs_ready():

 var stairs_scene = load(STAIRS_SCENE)
 var stairs = stairs_scene.instantiate()

 add_child(stairs)
 await get_tree().process_frame  # Allow _ready() to execute

 # Might not need assertions for initialization

 stairs.queue_free()
