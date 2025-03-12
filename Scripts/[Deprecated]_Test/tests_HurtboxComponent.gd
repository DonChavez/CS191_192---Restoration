class_name hurtboxComponent_UnitTest
extends GdUnitTestSuite

const HURTBOX_SCENE = "res://Scenes/Components/hurtbox_component.tscn" # Update with correct path
const HITBOX_SCENE = "res://Scenes/Components/hitbox_component.tscn"

func test_hurtbox_ready():

 var hurtbox_scene = load(HURTBOX_SCENE)
 var hurtbox = hurtbox_scene.instantiate()

 add_child(hurtbox)
 await get_tree().process_frame  # Allow _ready() to execute
	

func test_hurtbox_hitbox_entered():
 #Load and Initialize (Use other components as reference)
 var hurtbox_scene = load(HURTBOX_SCENE)

 const hitboxComponent_Test = preload("res://Scripts/Components/HitboxComponent.gd")
 const healthComponent_Test = preload("res://Scripts/Components/HealthComponent.gd")

 var health_component = healthComponent_Test.new()
 var hitbox_component = hitboxComponent_Test.new()
 var sample_sound = AudioStreamPlayer2D.new()

 sample_sound.name = "AudioStreamPlayer2D"
 
 var hurtbox = hurtbox_scene.instantiate()

 health_component._ready()

 hitbox_component.health_component = health_component
 hitbox_component.interaction_sound = sample_sound

 hurtbox.add_child(hitbox_component)

 add_child(hurtbox)
 await get_tree().process_frame

 #Actual Test
 hurtbox._on_hitbox_entered(hitbox_component)
 assert_float(hitbox_component.health_component.health).is_equal(99.0)

 health_component.queue_free()
 hitbox_component.queue_free()
 sample_sound.queue_free()
