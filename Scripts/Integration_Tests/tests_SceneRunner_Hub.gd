class_name Integration_Tests_SceneRunner_Hub
extends GdUnitTestSuite

func test_simulate_initialization(timeout = 5000) -> void:
# Create the scene runner for scene `test_scene.tscn`
 var runner := scene_runner("res://Scripts/Integration_Tests/SAMPLE_SCENES/HubTestingArea.tscn")
 var test_player = runner.invoke("find_child", "Player")
 #test_player.invoke("_ready")
## Get access to scene property '_box1'
 #var box1: ColorRect = runner.get_property("_box1")
## Verify it is initially set to white
 #await await_millis(500)
 #assert_object(box1.color).is_equal(Color.WHITE)
 assert_bool(test_player.Player_is_dead).is_false()
 assert_bool(test_player.Melee_hurtbox.monitoring).is_true()
 assert_bool(test_player.Melee_hurtbox.visible).is_true()
 assert_bool(test_player.Tempo_shield.visible).is_true()
 assert_bool(test_player.Tempo_shield.monitoring).is_true()
 assert_bool(test_player.Tempo_shield.monitorable).is_true()
 assert_bool(test_player.TS_hitbox.monitoring).is_true()
 assert_bool(test_player.TS_hitbox.monitorable).is_true()
 assert_bool(test_player.TS_hitbox.visible).is_true()


## Start the color cycle by invoking the function 'start_color_cycle' and await 10 frames being processed
 #runner.invoke("start_color_cycle")        
 #await runner.simulate_frames(10)
#
## After 10 frames, the color should have changed to black
 #assert_object(box1.color).is_equal(Color.BLACK)

 # Simulate scene processing over 60 frames at normal speed
 await runner.simulate_frames(50)


func test_simulate_tree_planting(timeout = 20000) -> void:
# Create the scene runner for scene `test_scene.tscn`
 var runner := scene_runner("res://Scripts/Integration_Tests/SAMPLE_SCENES/HubTestingArea.tscn")
 var test_player = runner.invoke("find_child", "Player")
 #test_player._ready()

#var Facing_direction : String = "right"

 await runner.simulate_frames(50)

 runner.simulate_key_press(KEY_A)
 await runner.simulate_frames(380)
 runner.simulate_key_release(KEY_A)

 runner.simulate_key_press(KEY_W)
 await runner.simulate_frames(30)
 runner.simulate_key_release(KEY_W)

 runner.simulate_key_press(KEY_F)
 await runner.simulate_frames(10)
 runner.simulate_key_release(KEY_F)
 await runner.simulate_frames(1000)

 await runner.simulate_frames(50)

func test_simulate_movement(timeout = 20000) -> void:
# Create the scene runner for scene `test_scene.tscn`
 var runner := scene_runner("res://Scripts/Integration_Tests/SAMPLE_SCENES/HubTestingArea.tscn")
 var test_player = runner.invoke("find_child", "Player")
 #test_player._ready()

#var Facing_direction : String = "right"

 await runner.simulate_frames(50)

 runner.simulate_key_press(KEY_A)
 await runner.simulate_frames(380)
 runner.simulate_key_release(KEY_A)

 runner.simulate_key_press(KEY_S)
 await runner.simulate_frames(30)
 runner.simulate_key_release(KEY_S)

 runner.simulate_key_press(KEY_F)
 await runner.simulate_frames(10)
 runner.simulate_key_release(KEY_F)
 await runner.simulate_frames(1000)

 await runner.simulate_frames(50)
