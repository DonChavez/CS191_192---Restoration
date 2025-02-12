class_name chest_UnitTest
extends GdUnitTestSuite

const chest_Test = preload("res://Scripts/chest.gd")


func test_chest_initialize() -> void:
	
 var chest = chest_Test.new()
 var label = Label.new()
 var panel = Panel.new()
 var animated_sprite = AnimatedSprite2D.new()

 label.name = "Label"  
 panel.name = "Panel"
 animated_sprite.name = "AnimatedSprite2D"

 chest.add_child(label)
 chest.add_child(panel)
 chest.add_child(animated_sprite)

 # Setup done, Testing ready

 chest._ready()

 assert_bool(chest.panel.visible).is_false()
 assert_bool(chest.label.visible).is_false()

 chest.queue_free()
 label.queue_free()
 animated_sprite.queue_free()
 panel.queue_free()


func test_chest_interact_open() -> void:
	
 var chest = chest_Test.new()
 var label = Label.new()
 var panel = Panel.new()
 var animated_sprite = AnimatedSprite2D.new()

 label.name = "Label"  
 panel.name = "Panel"
 animated_sprite.name = "AnimatedSprite2D"

 chest.add_child(label)
 chest.add_child(panel)
 chest.add_child(animated_sprite)

 # Setup done, Testing ready

 chest._ready()
 chest.interact()

 assert_bool(chest.panel.visible).is_true()

 chest.queue_free()
 label.queue_free()
 animated_sprite.queue_free()
 panel.queue_free()


func test_chest_interact_close() -> void:
	
 var chest = chest_Test.new()
 var label = Label.new()
 var panel = Panel.new()
 var animated_sprite = AnimatedSprite2D.new()

 label.name = "Label"  
 panel.name = "Panel"
 animated_sprite.name = "AnimatedSprite2D"

 chest.add_child(label)
 chest.add_child(panel)
 chest.add_child(animated_sprite)

 # Setup done, Testing ready

 chest._ready()
 chest.interact()

 assert_bool(chest.panel.visible).is_true()

 chest.interact()

 assert_bool(chest.panel.visible).is_false()

 chest.queue_free()
 label.queue_free()
 animated_sprite.queue_free()
 panel.queue_free()


func test_chest_entered_vicinity() -> void:
	
 var chest = chest_Test.new()
 var label = Label.new()
 var panel = Panel.new()
 var animated_sprite = AnimatedSprite2D.new()
 var chest_area = Node2D.new()

 label.name = "Label"  
 panel.name = "Panel"
 animated_sprite.name = "AnimatedSprite2D"

 chest.add_child(label)
 chest.add_child(panel)
 chest.add_child(animated_sprite)

 # Setup done, Testing ready

 chest._ready()
 chest._on_area_2d_body_entered(chest_area)

 assert_bool(chest.label.visible).is_true()
 assert_bool(chest.player_nearby).is_true()



 chest.queue_free()
 label.queue_free()
 animated_sprite.queue_free()
 panel.queue_free()
 chest_area.queue_free()

func test_chest_exited_vicinity() -> void:
	
 var chest = chest_Test.new()
 var label = Label.new()
 var panel = Panel.new()
 var animated_sprite = AnimatedSprite2D.new()
 var chest_area = Node2D.new()

 label.name = "Label"  
 panel.name = "Panel"
 animated_sprite.name = "AnimatedSprite2D"

 chest.add_child(label)
 chest.add_child(panel)
 chest.add_child(animated_sprite)

 # Setup done, Testing ready

 chest._ready()
 chest._on_area_2d_body_entered(chest_area)
 chest._on_area_2d_body_exited(chest_area)

 assert_bool(chest.label.visible).is_false()
 assert_bool(chest.label.visible).is_false()
 assert_bool(chest.player_nearby).is_false()



 chest.queue_free()
 label.queue_free()
 animated_sprite.queue_free()
 panel.queue_free()
 chest_area.queue_free()



# _Process delta will be added for tests in next sprint due to delta limitation
