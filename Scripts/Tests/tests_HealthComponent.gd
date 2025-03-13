class_name HealthComponent_UnitTest
extends GdUnitTestSuite


const HEALTHCOMPONENT_SCENE = "res://Scenes/Components/HealthComponent.tscn"  # Update with correct path


func test_healthcomponent_ready():

 var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 var healthcomponent = healthcomponent_scene.instantiate()


 #var input_label = recycler.get_node("InputLabel")
 #var recycler_ui = recycler.get_node("RecyclerUI")

 add_child(healthcomponent)
 await get_tree().process_frame  # Allow _ready() to execute

 assert_float(healthcomponent.Health).is_equal(100.0)

 healthcomponent.queue_free()

func test_takedamage_dead():

 var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 var healthcomponent = healthcomponent_scene.instantiate()

 add_child(healthcomponent)
 await get_tree().process_frame  # Allow _ready() to execute

 healthcomponent.Health = 0
 healthcomponent.take_damage(50)
 #Assertions not needed, as long as function returns, test passes

 healthcomponent.queue_free()

func test_takedamage_will_live():

 var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 var healthcomponent = healthcomponent_scene.instantiate()

 add_child(healthcomponent)
 await get_tree().process_frame  # Allow _ready() to execute

 healthcomponent.take_damage(75.0)
 assert_float(healthcomponent.Health).is_equal(25.0)

 healthcomponent.queue_free()

func test_takedamage_will_die():

 var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 var healthcomponent = healthcomponent_scene.instantiate()

 add_child(healthcomponent)
 await get_tree().process_frame  # Allow _ready() to execute

 healthcomponent.take_damage(110.0)
 assert_float(healthcomponent.Health).is_equal(0.0)
 assert_bool(healthcomponent.Is_dead).is_true()

 healthcomponent.queue_free()

func test_takedamage_is_invul():

 var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 var healthcomponent = healthcomponent_scene.instantiate()

 add_child(healthcomponent)
 await get_tree().process_frame  # Allow _ready() to execute

 healthcomponent.Is_invulnerable = true
 healthcomponent.take_damage(75.0)
 assert_float(healthcomponent.Health).is_equal(100.0)

 healthcomponent.queue_free()

func test_heal_normal():

 var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 var healthcomponent = healthcomponent_scene.instantiate()

 add_child(healthcomponent)
 await get_tree().process_frame  # Allow _ready() to execute

 healthcomponent.take_damage(75.0)
 healthcomponent.heal(25.0)
 assert_float(healthcomponent.Health).is_equal(50.0)

 healthcomponent.queue_free()

func test_heal_overflow():

 var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 var healthcomponent = healthcomponent_scene.instantiate()

 add_child(healthcomponent)
 await get_tree().process_frame  # Allow _ready() to execute

 healthcomponent.take_damage(75.0)
 healthcomponent.heal(200.0)
 assert_float(healthcomponent.Health).is_equal(100.0)

 healthcomponent.queue_free()

func test_heal_already_dead():

 var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 var healthcomponent = healthcomponent_scene.instantiate()

 add_child(healthcomponent)
 await get_tree().process_frame  # Allow _ready() to execute

 healthcomponent.take_damage(110.0)
 healthcomponent.heal(200.0)
 assert_float(healthcomponent.Health).is_equal(0.0)

 healthcomponent.queue_free()
