class_name HitboxComponent_UnitTest
extends GdUnitTestSuite


const HITBOXCOMPONENT_SCENE = "res://Scenes/Components/HitboxComponent.tscn"  # Update with correct path
const HEALTHCOMPONENT_SCENE = "res://Scenes/Components/HealthComponent.tscn"


func test_healthcomponent_ready():

 var hitboxcomponent_scene = load(HITBOXCOMPONENT_SCENE)
 var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 var healthcomponent = healthcomponent_scene.instantiate()
 var hitboxcomponent = hitboxcomponent_scene.instantiate()

 hitboxcomponent.Health = healthcomponent
 hitboxcomponent.Health._ready()

 add_child(hitboxcomponent)
 await get_tree().process_frame  # Allow _ready() to execute

 #Assertions not needed, as long as function returns, test passes(Initialization does not mutate anything)
 healthcomponent.queue_free()
 hitboxcomponent.queue_free()

func test_healthcomponent_receivedamage_normal():
	
 var hitboxcomponent_scene = load(HITBOXCOMPONENT_SCENE)
 var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 var healthcomponent = healthcomponent_scene.instantiate()
 var hitboxcomponent = hitboxcomponent_scene.instantiate()

 hitboxcomponent.Health = healthcomponent
 hitboxcomponent.Health._ready()

 add_child(hitboxcomponent)
 await get_tree().process_frame  # Allow _ready() to execute

 hitboxcomponent.Time_since_last_damage = 1.0
 hitboxcomponent.damage_received(75.0)
 assert_float(hitboxcomponent.Time_since_last_damage).is_equal(0.0)
 assert_float(hitboxcomponent.Health.Health).is_equal(25.0)

 healthcomponent.queue_free()
 hitboxcomponent.queue_free()

func test_healthcomponent_receivedamage_iframed():
	
 var hitboxcomponent_scene = load(HITBOXCOMPONENT_SCENE)
 var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 var healthcomponent = healthcomponent_scene.instantiate()
 var hitboxcomponent = hitboxcomponent_scene.instantiate()

 hitboxcomponent.Health = healthcomponent
 hitboxcomponent.Health._ready()

 add_child(hitboxcomponent)
 await get_tree().process_frame  # Allow _ready() to execute

 hitboxcomponent.Time_since_last_damage = 0.01
 hitboxcomponent.damage_received(75.0)
 assert_float(hitboxcomponent.Time_since_last_damage).is_equal(0.01)
 assert_float(hitboxcomponent.Health.Health).is_equal(100.0)

 healthcomponent.queue_free()
 hitboxcomponent.queue_free()

func test_healthcomponent_receivedamage_subdamage():
	
 var hitboxcomponent_scene = load(HITBOXCOMPONENT_SCENE)
 var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 var healthcomponent = healthcomponent_scene.instantiate()
 var hitboxcomponent = hitboxcomponent_scene.instantiate()

 hitboxcomponent.Health = healthcomponent
 hitboxcomponent.Health._ready()

 add_child(hitboxcomponent)
 await get_tree().process_frame  # Allow _ready() to execute

 hitboxcomponent.Time_since_last_damage = 1.0
 hitboxcomponent.Substitute_damage = 50.0
 hitboxcomponent.damage_received(0.0)
 assert_float(hitboxcomponent.Time_since_last_damage).is_equal(0.0)
 assert_float(hitboxcomponent.Health.Health).is_equal(50.0)

 healthcomponent.queue_free()
 hitboxcomponent.queue_free()

#DO NOT TEST LIVE UPDATE FUNCTIONS(EX: Physics Process... etc). That's for BDD ++ SceneRunner if Available
