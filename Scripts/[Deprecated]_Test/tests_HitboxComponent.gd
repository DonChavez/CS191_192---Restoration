class_name hitboxComponent_UnitTest
extends GdUnitTestSuite

const hitboxComponent_Test = preload("res://Scripts/Components/HitboxComponent.gd")
const healthComponent_Test = preload("res://Scripts/Components/HealthComponent.gd")



func test_health_label_ready():
 
 var health_component = healthComponent_Test.new()
 var hitbox_component = hitboxComponent_Test.new()
 var sample_sound = AudioStreamPlayer2D.new()

 sample_sound.name = "AudioStreamPlayer2D"

 health_component._ready()

 hitbox_component.health_component = health_component
 hitbox_component.interaction_sound = sample_sound

 hitbox_component.damage_received(70.0)
 assert_float(hitbox_component.health_component.health).is_equal(30.0)

 health_component.queue_free()
 hitbox_component.queue_free()
 sample_sound.queue_free()

 

 
