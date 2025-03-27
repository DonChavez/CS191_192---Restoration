class_name Integration_Tests_SceneRunner_Foundation
extends GdUnitTestSuite

func free_all_orphan_nodes():
 var orphans = []
 for node in get_tree().get_nodes_in_group(""):
  if node.get_parent() == null:
   orphans.append(node)

 for orphan in orphans:
  print("Freeing orphan node:", orphan.name)
  if is_instance_valid(orphan):
   orphan.queue_free()

func test_simulate_initialization(timeout = 5000) -> void:
# Create the scene runner for scene `test_scene.tscn`
 var runner := scene_runner("res://Scripts/Integration_Tests/SAMPLE_SCENES/BaseTestingArea.tscn")
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


func test_simulate_movement(timeout = 10000) -> void:
# Create the scene runner for scene `test_scene.tscn`
 var runner := scene_runner("res://Scripts/Integration_Tests/SAMPLE_SCENES/BaseTestingArea.tscn")
 var test_player = runner.invoke("find_child", "Player")
 #test_player._ready()

#var Facing_direction : String = "right"

 runner.simulate_key_press(KEY_A)
 await runner.simulate_frames(25)
 assert_str(test_player.Facing_direction).is_equal("left")
 await runner.simulate_frames(25)
 runner.simulate_key_release(KEY_A)

 runner.simulate_key_press(KEY_D)
 await runner.simulate_frames(75)
 assert_str(test_player.Facing_direction).is_equal("right")
 await runner.simulate_frames(75)
 runner.simulate_key_release(KEY_D)

 runner.simulate_key_press(KEY_W)
 await runner.simulate_frames(25)
 assert_str(test_player.Facing_direction).is_equal("up")
 await runner.simulate_frames(25)
 runner.simulate_key_release(KEY_W)

 runner.simulate_key_press(KEY_S)
 await runner.simulate_frames(50)
 assert_str(test_player.Facing_direction).is_equal("down")
 await runner.simulate_frames(50)
 runner.simulate_key_release(KEY_S)

 runner.simulate_key_press(KEY_W)
 await runner.simulate_frames(25)
 assert_str(test_player.Facing_direction).is_equal("up")
 await runner.simulate_frames(25)
 runner.simulate_key_release(KEY_W)

 await runner.simulate_frames(50)




func test_simulate_Attack(timeout = 10000) -> void:
# Create the scene runner for scene `test_scene.tscn`
 var runner := scene_runner("res://Scripts/Integration_Tests/SAMPLE_SCENES/BaseTestingArea.tscn")
 var test_player = runner.invoke("find_child", "Player")
 test_player._ready()

#var Facing_direction : String = "right"
 await runner.simulate_frames(100)

 runner.simulate_key_press(KEY_F)
 await runner.simulate_frames(25)
 runner.simulate_key_release(KEY_F)

 runner.simulate_key_press(KEY_F)
 await runner.simulate_frames(25)
 runner.simulate_key_release(KEY_F)

 runner.simulate_key_press(KEY_D)
 await runner.simulate_frames(100)
 runner.simulate_key_release(KEY_D)

 runner.simulate_key_press(KEY_W)
 await runner.simulate_frames(100)
 runner.simulate_key_release(KEY_W)

 runner.simulate_key_press(KEY_D)
 await runner.simulate_frames(100)
 runner.simulate_key_release(KEY_D)

 #await runner.simulate_mouse_move_absolute(Vector2(1000, 1000), 1)
 

 runner.set_mouse_pos(Vector2(1400, 380))
 await runner.await_input_processed()


 ## Simulate a mouse move from the current position to the relative position within 1 second
 ## the final position will be (410, 220) when is completed
 ##runner.simulate_mouse_button_press(MOUSE_BUTTON_RIGHT)
 ##await runner.simulate_frames(50)
 ##runner.simulate_mouse_button_release(MOUSE_BUTTON_RIGHT)
 ##await runner.simulate_mouse_move_relative(Vector2(500, 180), 0.2)

 runner.simulate_action_press("attack")
 await runner.simulate_frames(100)
 runner.simulate_action_release("attack")

 runner.simulate_action_press("attack")
 await runner.simulate_frames(100)
 runner.simulate_action_release("attack")

 runner.simulate_action_press("attack")
 await runner.simulate_frames(100)
 runner.simulate_action_release("attack")

 ##runner.simulate_key_press(KEY_BACKSPACE)
 ##await runner.simulate_frames(25)
 ##runner.simulate_key_release(KEY_BACKSPACE)
#
 ##runner.simulate_action_press("shoot")
 ##await runner.simulate_frames(100)
 ##runner.simulate_action_release("shoot")
#
 ##runner.set_mouse_pos(Vector2(160, 20))
 ##await runner.await_input_processed()
##
 ##runner.simulate_mouse_move(Vector2(200, 40))
 ##await runner.await_input_processed()

 free_all_orphan_nodes()
#
 await runner.simulate_frames(50)




func test_simulate_Kill(timeout = 10000) -> void:
# Create the scene runner for scene `test_scene.tscn`
 var runner := scene_runner("res://Scripts/Integration_Tests/SAMPLE_SCENES/BaseTestingArea.tscn")
 var test_player = runner.invoke("find_child", "Player")
 test_player._ready()

 await runner.simulate_frames(100)

 runner.simulate_key_press(KEY_F)
 await runner.simulate_frames(25)
 runner.simulate_key_release(KEY_F)

 runner.simulate_key_press(KEY_F)
 await runner.simulate_frames(25)
 runner.simulate_key_release(KEY_F)

 await runner.simulate_frames(25)

 runner.simulate_key_press(KEY_D)
 await runner.simulate_frames(175)
 runner.simulate_key_release(KEY_D)

 runner.simulate_key_press(KEY_W)
 await runner.simulate_frames(185)
 runner.simulate_key_release(KEY_W)

 runner.simulate_key_press(KEY_D)
 await runner.simulate_frames(60)
 runner.simulate_key_release(KEY_D)
 
 runner.set_mouse_pos(Vector2(1400, 380))
 await runner.await_input_processed()

 runner.simulate_mouse_button_press(MOUSE_BUTTON_RIGHT)
 await runner.simulate_frames(50)
 runner.simulate_mouse_button_release(MOUSE_BUTTON_RIGHT)

 runner.simulate_action_press("attack")
 await runner.simulate_frames(100)
 runner.simulate_action_release("attack")

 runner.simulate_action_press("attack")
 await runner.simulate_frames(100)
 runner.simulate_action_press("attack")

 runner.simulate_action_press("attack")
 await runner.simulate_frames(100)
 runner.simulate_action_release("attack")


 await runner.simulate_frames(50)

func test_simulate_damaged(timeout = 10000) -> void:
# Create the scene runner for scene `test_scene.tscn`
 var runner := scene_runner("res://Scripts/Integration_Tests/SAMPLE_SCENES/BaseTestingArea.tscn")
 var test_player = runner.invoke("find_child", "Player")
 test_player._ready()

 await runner.simulate_frames(100)

 runner.simulate_key_press(KEY_F)
 await runner.simulate_frames(25)
 runner.simulate_key_release(KEY_F)

 runner.simulate_key_press(KEY_F)
 await runner.simulate_frames(25)
 runner.simulate_key_release(KEY_F)

 runner.simulate_key_press(KEY_D)
 await runner.simulate_frames(150)
 runner.simulate_key_release(KEY_D)

 runner.simulate_key_press(KEY_W)
 await runner.simulate_frames(185)
 runner.simulate_key_release(KEY_W)

 runner.simulate_key_press(KEY_D)
 await runner.simulate_frames(120)
 runner.simulate_key_release(KEY_D)
 
 runner.set_mouse_pos(Vector2(1400, 380))
 await runner.await_input_processed()

 await runner.simulate_frames(100)

 await runner.simulate_frames(50)



func test_simulate_Block(timeout = 10000) -> void:
# Create the scene runner for scene `test_scene.tscn`
 var runner := scene_runner("res://Scripts/Integration_Tests/SAMPLE_SCENES/BaseTestingArea.tscn")
 var test_player = runner.invoke("find_child", "Player")
 test_player._ready()

 await runner.simulate_frames(100)

 runner.simulate_key_press(KEY_F)
 await runner.simulate_frames(25)
 runner.simulate_key_release(KEY_F)

 runner.simulate_key_press(KEY_F)
 await runner.simulate_frames(25)
 runner.simulate_key_release(KEY_F)

 runner.simulate_key_press(KEY_D)
 await runner.simulate_frames(150)
 runner.simulate_key_release(KEY_D)

 runner.simulate_key_press(KEY_W)
 await runner.simulate_frames(185)
 runner.simulate_key_release(KEY_W)

 runner.simulate_key_press(KEY_D)
 await runner.simulate_frames(55)
 runner.simulate_key_release(KEY_D)
 
 runner.set_mouse_pos(Vector2(1400, 380))
 await runner.await_input_processed()

 runner.simulate_mouse_button_press(MOUSE_BUTTON_RIGHT)
 await runner.simulate_frames(150)
 runner.simulate_mouse_button_release(MOUSE_BUTTON_RIGHT)


 await runner.simulate_frames(50)


func test_simulate_Tower(timeout = 15000) -> void:
# Create the scene runner for scene `test_scene.tscn`
 var runner := scene_runner("res://Scripts/Integration_Tests/SAMPLE_SCENES/BaseTestingArea.tscn")
 var test_player = runner.invoke("find_child", "Player")
 test_player._ready()

 await runner.simulate_frames(100)

 runner.simulate_key_press(KEY_F)
 await runner.simulate_frames(25)
 runner.simulate_key_release(KEY_F)

 runner.simulate_key_press(KEY_F)
 await runner.simulate_frames(25)
 runner.simulate_key_release(KEY_F)

 runner.simulate_key_press(KEY_D)
 await runner.simulate_frames(450)
 runner.simulate_key_release(KEY_D)

 runner.simulate_key_press(KEY_W)
 await runner.simulate_frames(175)
 runner.simulate_key_release(KEY_W)
 
 runner.set_mouse_pos(Vector2(1400, 380))
 await runner.await_input_processed()

 runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
 await runner.simulate_frames(50)
 runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)

 await runner.simulate_frames(50)



#func test_simulate_portal(timeout = 5000) -> void:
## Create the scene runner for scene `test_scene.tscn`
 #var runner := scene_runner("res://Scripts/Integration_Tests/SAMPLE_SCENES/BaseTestingArea.tscn")
 #var test_player = runner.invoke("find_child", "Player")
 #test_player._ready()
#
##var Facing_direction : String = "right"
#
 #runner.simulate_key_press(KEY_D)
 #await runner.simulate_frames(150)
 #runner.simulate_key_release(KEY_D)
#
 #runner.simulate_key_press(KEY_F)
 #await runner.simulate_frames(25)
 #runner.simulate_key_release(KEY_F)
 #await runner.simulate_frames(500)
#
#
 #await runner.simulate_frames(50)
