class_name HurtboxComponent_UnitTest
extends GdUnitTestSuite


const HITBOXCOMPONENT_SCENE = "res://Scenes/Components/HitboxComponent.tscn"  # Update with correct path
const HURTBOXCOMPONENT_SCENE = "res://Scenes/Components/HurtboxComponent.tscn"
const HEALTHCOMPONENT_SCENE = "res://Scenes/Components/HealthComponent.tscn"


func test_hurtboxcomponent_ready():

 var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 var hurtboxcomponent_scene = load(HURTBOXCOMPONENT_SCENE)
 var hitboxcomponent_scene = load(HITBOXCOMPONENT_SCENE)
 var hitboxcomponent = hitboxcomponent_scene.instantiate()
 var hurtboxcomponent = hurtboxcomponent_scene.instantiate()
 var healthcomponent = healthcomponent_scene.instantiate()

 hitboxcomponent.Health = healthcomponent
 hitboxcomponent.Health._ready()

 #No assignment of hitboxcomponent to hurtbox initially, default it is set to null

 add_child(hurtboxcomponent)
 await get_tree().process_frame  # Allow _ready() to execute

 #Assertions not needed, as long as function returns, test passes(Initialization does not mutate anything)

 healthcomponent.queue_free()
 hitboxcomponent.queue_free()
 hurtboxcomponent.queue_free()

func test_hurtboxcomponent_hitbox_entered():

 var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 var hurtboxcomponent_scene = load(HURTBOXCOMPONENT_SCENE)
 var hitboxcomponent_scene = load(HITBOXCOMPONENT_SCENE)
 var hitboxcomponent = hitboxcomponent_scene.instantiate()
 var hurtboxcomponent = hurtboxcomponent_scene.instantiate()
 var healthcomponent = healthcomponent_scene.instantiate()

 hitboxcomponent.Health = healthcomponent
 hitboxcomponent.Health._ready()
 #hurtboxcomponent.Hitbox = hitboxcomponent

 add_child(hurtboxcomponent)
 await get_tree().process_frame  # Allow _ready() to execute

 hurtboxcomponent.monitoring = true
 hurtboxcomponent._on_hitbox_entered(hitboxcomponent)

 assert_float(hurtboxcomponent.Time_since_last_damage).is_equal(0.0)

 healthcomponent.queue_free()
 hitboxcomponent.queue_free()
 hurtboxcomponent.queue_free()

func test_hurtboxcomponent_hitbox_exited():

 var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 var hurtboxcomponent_scene = load(HURTBOXCOMPONENT_SCENE)
 var hitboxcomponent_scene = load(HITBOXCOMPONENT_SCENE)
 var hitboxcomponent = hitboxcomponent_scene.instantiate()
 var hurtboxcomponent = hurtboxcomponent_scene.instantiate()
 var healthcomponent = healthcomponent_scene.instantiate()

 hitboxcomponent.Health = healthcomponent
 hitboxcomponent.Health._ready()
 #hurtboxcomponent.Hitbox = hitboxcomponent

 add_child(hurtboxcomponent)
 await get_tree().process_frame  # Allow _ready() to execute

 hurtboxcomponent.monitoring = true
 hurtboxcomponent._on_hitbox_entered(hitboxcomponent)
 hurtboxcomponent._on_hitbox_exited(hitboxcomponent)

 assert_object(hurtboxcomponent.Hitbox_dict).is_equal({})

 healthcomponent.queue_free()
 hitboxcomponent.queue_free()
 hurtboxcomponent.queue_free()
