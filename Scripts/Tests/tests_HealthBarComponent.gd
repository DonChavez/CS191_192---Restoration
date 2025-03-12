class_name HealthBarComponent_UnitTest
extends GdUnitTestSuite


const HEALTHBARCOMPONENT_SCENE = "res://Scenes/Components/HealthBar.tscn"  # Update with correct path
const HEALTHCOMPONENT_SCENE = "res://Scenes/Components/HealthComponent.tscn"
const PLAYER_SCENE = "res://Scenes/Player/Player.tscn"
const SHIELD_SCENE = "res://Scenes/Player/Shield.tscn"
const ENEMY_SCENE = "res://Scenes/Enemies/BasicEnemy.tscn"


func test_hurtboxcomponent_ready_player():

 var player_scene = load(PLAYER_SCENE)
 var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 var healthbarcomponent_scene = load(HEALTHBARCOMPONENT_SCENE)
 var healthbarcomponent = healthbarcomponent_scene.instantiate()
 var healthcomponent = healthcomponent_scene.instantiate()
 var player = player_scene.instantiate()

 healthbarcomponent.Health_component = healthcomponent
 healthbarcomponent.Health_component._ready()

 player.add_child(healthbarcomponent)

 add_child(healthbarcomponent)
 await get_tree().process_frame  # Allow _ready() to execute

 #Assertions not needed, as long as function returns, test passes(Initialization does not mutate anything)

 healthcomponent.queue_free()
 healthbarcomponent.queue_free()
 player.queue_free()

func test_hurtboxcomponent_ready_shield():

 var shield_scene = load(SHIELD_SCENE)
 var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 var healthbarcomponent_scene = load(HEALTHBARCOMPONENT_SCENE)
 var healthbarcomponent = healthbarcomponent_scene.instantiate()
 var healthcomponent = healthcomponent_scene.instantiate()
 var shield = shield_scene.instantiate()

 healthbarcomponent.Health_component = healthcomponent
 healthbarcomponent.Health_component._ready()

 shield.add_child(healthbarcomponent)

 add_child(healthbarcomponent)
 await get_tree().process_frame  # Allow _ready() to execute

 #Assertions not needed, as long as function returns, test passes(Initialization does not mutate anything)

 healthcomponent.queue_free()
 healthbarcomponent.queue_free()
 shield.queue_free()

func test_hurtboxcomponent_ready_enemy():

 var enemy_scene = load(ENEMY_SCENE)
 var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 var healthbarcomponent_scene = load(HEALTHBARCOMPONENT_SCENE)
 var healthbarcomponent = healthbarcomponent_scene.instantiate()
 var healthcomponent = healthcomponent_scene.instantiate()
 var enemy = enemy_scene.instantiate()

 healthbarcomponent.Health_component = healthcomponent
 healthbarcomponent.Health_component._ready()

 enemy.add_child(healthbarcomponent)

 add_child(healthbarcomponent)
 await get_tree().process_frame  # Allow _ready() to execute

 #Assertions not needed, as long as function returns, test passes(Initialization does not mutate anything)

 healthcomponent.queue_free()
 healthbarcomponent.queue_free()
 enemy.queue_free()

func test_hurtboxcomponent_healthchanged_normal():

 var player_scene = load(PLAYER_SCENE)
 var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 var healthbarcomponent_scene = load(HEALTHBARCOMPONENT_SCENE)
 var healthbarcomponent = healthbarcomponent_scene.instantiate()
 var healthcomponent = healthcomponent_scene.instantiate()
 var player = player_scene.instantiate()

 healthbarcomponent.Health_component = healthcomponent
 healthbarcomponent.Health_component._ready()

 player.add_child(healthbarcomponent)

 add_child(healthbarcomponent)
 await get_tree().process_frame  # Allow _ready() to execute

 healthbarcomponent._on_health_changed(75.0)
 
 assert_float(healthbarcomponent.value).is_equal(75.0)
 assert_bool(healthbarcomponent.visible).is_true()

 healthcomponent.queue_free()
 healthbarcomponent.queue_free()
 player.queue_free()

func test_hurtboxcomponent_healthchanged_dead():

 var player_scene = load(PLAYER_SCENE)
 var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 var healthbarcomponent_scene = load(HEALTHBARCOMPONENT_SCENE)
 var healthbarcomponent = healthbarcomponent_scene.instantiate()
 var healthcomponent = healthcomponent_scene.instantiate()
 var player = player_scene.instantiate()

 healthbarcomponent.Health_component = healthcomponent
 healthbarcomponent.Health_component._ready()

 player.add_child(healthbarcomponent)

 add_child(healthbarcomponent)
 await get_tree().process_frame  # Allow _ready() to execute

 healthbarcomponent._on_health_changed(0.0)
 
 assert_float(healthbarcomponent.value).is_equal(0.0)
 assert_bool(healthbarcomponent.visible).is_false()

 healthcomponent.queue_free()
 healthbarcomponent.queue_free()
 player.queue_free()
