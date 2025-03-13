class_name BasicEnemy_UnitTest
extends GdUnitTestSuite


const ENEMY_SCENE = "res://Scenes/Enemies/BasicEnemy.tscn"  # Update with correct path
const HITBOXCOMPONENT_SCENE = "res://Scenes/Components/HitboxComponent.tscn"
const HEALTHCOMPONENT_SCENE = "res://Scenes/Components/HealthComponent.tscn"

func test_enemy_ready():

 var enemy_scene = load(ENEMY_SCENE)
 var hitboxcomponent_scene = load(HITBOXCOMPONENT_SCENE)
 var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 var enemy = enemy_scene.instantiate()
 var healthcomponent = healthcomponent_scene.instantiate()
 var hitboxcomponent = hitboxcomponent_scene.instantiate()

 hitboxcomponent.Health = healthcomponent
 hitboxcomponent.Health._ready()

 enemy.BE_health = healthcomponent
 enemy.BE_hitbox = hitboxcomponent

 var BE_sprite = enemy.get_node("AnimatedSprite2D")

 add_child(enemy)
 await get_tree().process_frame  # Allow _ready() to execute

 #Assertions not needed, as long as function returns, test passes(Initialization does not mutate anything)

 enemy.queue_free()
 healthcomponent.queue_free()
 hitboxcomponent.queue_free()

func test_enemy_detect_enter():
 var enemy_scene = load(ENEMY_SCENE)
 var hitboxcomponent_scene = load(HITBOXCOMPONENT_SCENE)
 var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 var enemy = enemy_scene.instantiate()
 var healthcomponent = healthcomponent_scene.instantiate()
 var hitboxcomponent = hitboxcomponent_scene.instantiate()

 hitboxcomponent.Health = healthcomponent
 hitboxcomponent.Health._ready()

 enemy.BE_health = healthcomponent
 enemy.BE_hitbox = hitboxcomponent

 var BE_sprite = enemy.get_node("AnimatedSprite2D")

 var sample_body = Node2D.new()

 add_child(enemy)
 await get_tree().process_frame  # Allow _ready() to execute

 enemy._on_detection_area_body_entered(sample_body)
 
 assert_bool(enemy.Player_chase).is_true()
 
 enemy.queue_free()
 sample_body.queue_free()
 healthcomponent.queue_free()
 hitboxcomponent.queue_free()

func test_enemy_detect_exit():
 var enemy_scene = load(ENEMY_SCENE)
 var hitboxcomponent_scene = load(HITBOXCOMPONENT_SCENE)
 var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 var enemy = enemy_scene.instantiate()
 var healthcomponent = healthcomponent_scene.instantiate()
 var hitboxcomponent = hitboxcomponent_scene.instantiate()

 hitboxcomponent.Health = healthcomponent
 hitboxcomponent.Health._ready()

 enemy.BE_health = healthcomponent
 enemy.BE_hitbox = hitboxcomponent

 var BE_sprite = enemy.get_node("AnimatedSprite2D")

 var sample_body = Node2D.new()

 add_child(enemy)
 await get_tree().process_frame  # Allow _ready() to execute

 enemy._on_detection_area_body_entered(sample_body)
 enemy._on_detection_area_body_exited(sample_body)
 
 assert_bool(enemy.Player_chase).is_false()
 
 enemy.queue_free()
 sample_body.queue_free()
 healthcomponent.queue_free()
 hitboxcomponent.queue_free()

func test_enemy_alive():
 var enemy_scene = load(ENEMY_SCENE)
 var hitboxcomponent_scene = load(HITBOXCOMPONENT_SCENE)
 var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 var enemy = enemy_scene.instantiate()
 var healthcomponent = healthcomponent_scene.instantiate()
 var hitboxcomponent = hitboxcomponent_scene.instantiate()

 hitboxcomponent.Health = healthcomponent
 hitboxcomponent.Health._ready()

 enemy.BE_health = healthcomponent
 enemy.BE_hitbox = hitboxcomponent

 var BE_sprite = enemy.get_node("AnimatedSprite2D")

 var sample_body = Node2D.new()

 add_child(enemy)
 await get_tree().process_frame  # Allow _ready() to execute

 assert_bool(enemy.is_dead()).is_false()
 
 enemy.queue_free()
 sample_body.queue_free()
 healthcomponent.queue_free()
 hitboxcomponent.queue_free()

func test_enemy_dead_detect():
 var enemy_scene = load(ENEMY_SCENE)
 var hitboxcomponent_scene = load(HITBOXCOMPONENT_SCENE)
 var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 var enemy = enemy_scene.instantiate()
 var healthcomponent = healthcomponent_scene.instantiate()
 var hitboxcomponent = hitboxcomponent_scene.instantiate()

 hitboxcomponent.Health = healthcomponent
 hitboxcomponent.Health._ready()

 enemy.BE_health = healthcomponent
 enemy.BE_hitbox = hitboxcomponent

 var BE_sprite = enemy.get_node("AnimatedSprite2D")

 var sample_body = Node2D.new()

 add_child(enemy)
 await get_tree().process_frame  # Allow _ready() to execute

 enemy.BE_health.take_damage(100.0)

 assert_bool(enemy.is_dead()).is_true()
 
 enemy.queue_free()
 sample_body.queue_free()
 healthcomponent.queue_free()
 hitboxcomponent.queue_free()

func test_enemy_dead():
 var enemy_scene = load(ENEMY_SCENE)
 var hitboxcomponent_scene = load(HITBOXCOMPONENT_SCENE)
 var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 var enemy = enemy_scene.instantiate()
 var healthcomponent = healthcomponent_scene.instantiate()
 var hitboxcomponent = hitboxcomponent_scene.instantiate()

 hitboxcomponent.Health = healthcomponent
 hitboxcomponent.Health._ready()

 enemy.BE_health = healthcomponent
 enemy.BE_hitbox = hitboxcomponent

 var BE_sprite = enemy.get_node("AnimatedSprite2D")

 var sample_body = Node2D.new()

 add_child(enemy)
 await get_tree().process_frame  # Allow _ready() to execute

 enemy.BE_health.take_damage(100.0)
 enemy.enemy_dead()

 assert_bool(enemy.is_dead()).is_true()
 assert_bool(enemy.BE_hitbox.monitoring).is_false()
 
 enemy.queue_free()
 sample_body.queue_free()
 healthcomponent.queue_free()
 hitboxcomponent.queue_free()
