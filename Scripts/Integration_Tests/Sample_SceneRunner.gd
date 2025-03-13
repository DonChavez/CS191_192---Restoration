class_name Temporary_Sample_Integration_Tests_SceneRunner
extends GdUnitTestSuite

func test_simulate_frames(timeout = 5000) -> void:
# Create the scene runner for scene `test_scene.tscn`
 var runner := scene_runner("res://Scenes/Levels/TestingArea/BaseTestingArea.tscn")

## Get access to scene property '_box1'
 #var box1: ColorRect = runner.get_property("_box1")
## Verify it is initially set to white
 #assert_object(box1.color).is_equal(Color.WHITE)
	#
## Start the color cycle by invoking the function 'start_color_cycle' and await 10 frames being processed
 #runner.invoke("start_color_cycle")        
 #await runner.simulate_frames(10)
#
## After 10 frames, the color should have changed to black
 #assert_object(box1.color).is_equal(Color.BLACK)

 # Simulate scene processing over 60 frames at normal speed
 await runner.simulate_frames(3000)
