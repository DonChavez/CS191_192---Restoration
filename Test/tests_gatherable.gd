class_name gatherable_UnitTest
extends GdUnitTestSuite

const gatherable_Test = preload("res://Scripts/gatherable.gd")

func test_gatherable_initialize() -> void:
	
 var gatherable = gatherable_Test.new()
 var label = Label.new()
 var animated_sprite = AnimatedSprite2D.new()

 animated_sprite.name = "AnimatedSprite2D"
 label.name = "Label" 

 gatherable.add_child(label)
 gatherable.add_child(animated_sprite)

 gatherable._ready()

 assert_str(gatherable.animated_sprite.animation).is_equal("default")
 assert_bool(gatherable.prompt_label.visible).is_false()
 assert_bool(gatherable.player_nearby).is_false()

 gatherable.queue_free()
 label.queue_free()
 animated_sprite.queue_free()

func test_gatherable_enter_vicinity() -> void:
	
 var gatherable = gatherable_Test.new()
 var label = Label.new()
 var animated_sprite = AnimatedSprite2D.new()
 var sample_object = Node.new()

 animated_sprite.name = "AnimatedSprite2D"
 label.name = "Label" 

 gatherable.add_child(label)
 gatherable.add_child(animated_sprite)

 gatherable._ready()
 gatherable._on_body_entered(sample_object)

 assert_bool(gatherable.player_nearby).is_true()
 assert_bool(gatherable.prompt_label.visible).is_true()

 gatherable.queue_free()
 label.queue_free()
 animated_sprite.queue_free()
 sample_object.queue_free()


func test_gatherable_exit_vicinity() -> void:
	
 var gatherable = gatherable_Test.new()
 var label = Label.new()
 var animated_sprite = AnimatedSprite2D.new()
 var sample_object = Node2D.new()

 animated_sprite.name = "AnimatedSprite2D"
 label.name = "Label" 

 gatherable.add_child(label)
 gatherable.add_child(animated_sprite)

 gatherable._ready()
 gatherable._on_body_exited(sample_object)

 assert_bool(gatherable.player_nearby).is_false()
 assert_bool(gatherable.prompt_label.visible).is_false()

 gatherable.queue_free()
 label.queue_free()
 animated_sprite.queue_free()
 sample_object.queue_free()


# interact && _process will be added for tests in next sprint due to issues with InventoryManager
