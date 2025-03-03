class_name interactable_UnitTest
extends GdUnitTestSuite

const interactable_Test = preload("res://Scripts/Components/Interactable.gd")

# Called when the node enters the scene tree for the first time.
func test_interactable() -> void:
	
 #Creating Scenes
 var interactable = interactable_Test.new()
 
 var label = Label.new()
 label.name = "Label"  # Must match the node name in the script

 var animated_sprite = AnimatedSprite2D.new()
 animated_sprite.name = "AnimatedSprite2D"

 interactable.add_child(label)
 interactable.add_child(animated_sprite)

 # Setup done, Testing ready

 interactable._ready()

 assert_bool(interactable.prompt_label.visible).is_false()
 # Should be spin, but whatever. Probably because there's only one animation?
 assert_str(interactable.animated_sprite.animation).is_equal("default")

 interactable.queue_free()
 label.queue_free()
 animated_sprite.queue_free()


func test_interactable_player_near_object() -> void:
	
 var interactable = interactable_Test.new()
 var label = Label.new()
 var animated_sprite = AnimatedSprite2D.new()
 var sample_object = Node.new()
 label.name = "Label"  # Must match the node name in the script
 animated_sprite.name = "AnimatedSprite2D"

 interactable.add_child(label)
 interactable.add_child(animated_sprite)

 # Setup done, Testing ready

 interactable._ready()

 
 interactable._on_body_entered(sample_object)
 assert_bool(interactable.player_nearby).is_true()
 assert_bool(interactable.prompt_label.visible).is_true()

 interactable.queue_free()
 label.queue_free()
 animated_sprite.queue_free()
 sample_object.queue_free()

 #var spy_interactable = spy(interactable)
 #spy_interactable.add_child(label)
 #spy_interactable.add_child(animated_sprite)
 #spy_interactable._ready()

 #Don't touch this plssss, will add extensive tests after sprint 1 
 #spy_interactable.player_nearby = true
 #Input.action_press("interact")
 #spy_interactable._process(0.016)
 #assert_bool(Input.is_action_just_pressed("interact")).is_true()
 #verify(spy_interactable, 1).interact()
 #Input.action_release("interact")

 # Cleanup: release the input action


func test_interactable_player_area_exited() -> void:
	
 var interactable = interactable_Test.new()
 var label = Label.new()
 var animated_sprite = AnimatedSprite2D.new()
 var sample_object = Node2D.new()
 label.name = "Label"  # Must match the node name in the script
 animated_sprite.name = "AnimatedSprite2D"

 interactable.add_child(label)
 interactable.add_child(animated_sprite)

 # Setup done, Testing ready

 interactable._ready()

 interactable._on_body_exited(sample_object)
 assert_bool(interactable.player_nearby).is_false()
 assert_bool(interactable.prompt_label.visible).is_false()

 interactable.queue_free()
 label.queue_free()
 animated_sprite.queue_free()
 sample_object.queue_free()







 #Implement in step 2, no touch


#func test_interactable_interact() -> void:
	#
 #var InventoryManager = preload("res://Levels/inventory_manager.gd")
	#
 #var interactable = interactable_Test.new()
 #var label = Label.new()
 #var animated_sprite = AnimatedSprite2D.new()
 #var interaction_sound = AudioStreamPlayer2D.new()
 #var inventory_manager = InventoryManager.new()
 #label.name = "Label"  # Must match the node name in the script
 #animated_sprite.name = "AnimatedSprite2D"
 #interaction_sound.name = "AudioStreamPlayer2D"
 #inventory_manager.name = "InventoryManager"
#
 #var spy_interactable = spy(interactable)
 #spy_interactable.add_child(label)
 #spy_interactable.add_child(animated_sprite)
 #spy_interactable.add_child(interaction_sound)
 ##spy_interactable.add_child(inventory_manager)
 #spy_interactable.inventory_manager = inventory_manager
 #
 #print("Inventory Manager: ", spy_interactable.inventory_manager)
#
 #spy_interactable._ready()
 #spy_interactable.interact()
#
 ## Setup done, Testing ready
#
#
 ##verify(spy_interactable, 1).print("Interacted with the object!")
 ##Input.action_release("interact")
#
 #interactable.queue_free()
 #label.queue_free()
 #animated_sprite.queue_free()
 #interaction_sound.queue_free()
 #inventory_manager.queue_free()






# Have to rewrite/optimize for cleanliness and extensiveness





 


 
 
