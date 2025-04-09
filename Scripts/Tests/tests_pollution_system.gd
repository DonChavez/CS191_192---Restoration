class_name PollutionSystem_UnitTest
extends GdUnitTestSuite


const POLLUTION_SYSTEM_SCENE = "res://Scenes/Pollution/PollutionSystem.tscn"  # Update with correct path
#const PROGRESS_BAR_SCENE = ""

func test_pollution_system_ready():

 var pollution_system_scene = load(POLLUTION_SYSTEM_SCENE)
 var pollution_system = pollution_system_scene.instantiate()

 add_child(pollution_system)
 await get_tree().process_frame  # Allow _ready() to execute
 
 #NO NEED FOR ASSERTIONS ON INITIALIZATION

 pollution_system.queue_free()
