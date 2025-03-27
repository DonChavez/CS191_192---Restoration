class_name RangedEnemy_UnitTest
extends GdUnitTestSuite


const RANGED_ENEMY_SCENE = "res://Scenes/Enemies/RangedEnemy.tscn"  # Update with correct path
const HITBOXCOMPONENT_SCENE = "res://Scenes/Components/HitboxComponent.tscn"
const HEALTHCOMPONENT_SCENE = "res://Scenes/Components/HealthComponent.tscn"

func test_ranged_enemy_ready():

 var ranged_enemy_scene = load(RANGED_ENEMY_SCENE)
 var hitboxcomponent_scene = load(HITBOXCOMPONENT_SCENE)
 var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 var ranged_enemy = ranged_enemy_scene.instantiate()
 var healthcomponent = healthcomponent_scene.instantiate()
 var hitboxcomponent = hitboxcomponent_scene.instantiate()

 hitboxcomponent.Health = healthcomponent
 hitboxcomponent.Health._ready()

 ranged_enemy.Ranged_health = healthcomponent
 ranged_enemy.Ranged_hitbox = hitboxcomponent

 var Ranged_sprite = ranged_enemy.get_node("AnimatedSprite2D")

 add_child(ranged_enemy)
 await get_tree().process_frame  # Allow _ready() to execute

 #Assertions not needed, Initialization(_ready) does not mutate anything of note

 ranged_enemy.queue_free()
 healthcomponent.queue_free()
 hitboxcomponent.queue_free()

#func test_ranged_enemy_detect_enter():
#
 #var ranged_enemy_scene = load(RANGED_ENEMY_SCENE)
 #var hitboxcomponent_scene = load(HITBOXCOMPONENT_SCENE)
 #var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 #var ranged_enemy = ranged_enemy_scene.instantiate()
 #var healthcomponent = healthcomponent_scene.instantiate()
 #var hitboxcomponent = hitboxcomponent_scene.instantiate()
#
 #hitboxcomponent.Health = healthcomponent
 #hitboxcomponent.Health._ready()
#
 #ranged_enemy.Ranged_health = healthcomponent
 #ranged_enemy.Ranged_hitbox = hitboxcomponent
#
 #var Ranged_sprite = ranged_enemy.get_node("AnimatedSprite2D")
#
 #var sample_body = Node2D.new()
#
 #add_child(ranged_enemy)
 #await get_tree().process_frame  # Allow _ready() to execute
#
 #ranged_enemy._on_detection_area_body_entered(sample_body)
 #assert_bool(ranged_enemy.Player_chase).is_true()
#
 #ranged_enemy.queue_free()
 #healthcomponent.queue_free()
 #hitboxcomponent.queue_free()
 #sample_body.queue_free()

func test_ranged_enemy_detect_exit():

 var ranged_enemy_scene = load(RANGED_ENEMY_SCENE)
 var hitboxcomponent_scene = load(HITBOXCOMPONENT_SCENE)
 var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 var ranged_enemy = ranged_enemy_scene.instantiate()
 var healthcomponent = healthcomponent_scene.instantiate()
 var hitboxcomponent = hitboxcomponent_scene.instantiate()

 hitboxcomponent.Health = healthcomponent
 hitboxcomponent.Health._ready()

 ranged_enemy.Ranged_health = healthcomponent
 ranged_enemy.Ranged_hitbox = hitboxcomponent

 var Ranged_sprite = ranged_enemy.get_node("AnimatedSprite2D")

 var sample_body = Node2D.new()

 add_child(ranged_enemy)
 await get_tree().process_frame  # Allow _ready() to execute

 ranged_enemy._on_detection_area_body_entered(sample_body)
 ranged_enemy._on_detection_area_body_exited(sample_body)

 assert_bool(ranged_enemy.Player_chase).is_false()

 ranged_enemy.queue_free()
 healthcomponent.queue_free()
 hitboxcomponent.queue_free()
 sample_body.queue_free()

#func test_ranged_enemy_shoot_projectile():
#
 #var ranged_enemy_scene = load(RANGED_ENEMY_SCENE)
 #var hitboxcomponent_scene = load(HITBOXCOMPONENT_SCENE)
 #var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 #var ranged_enemy = ranged_enemy_scene.instantiate()
 #var healthcomponent = healthcomponent_scene.instantiate()
 #var hitboxcomponent = hitboxcomponent_scene.instantiate()
#
 #hitboxcomponent.Health = healthcomponent
 #hitboxcomponent.Health._ready()
#
 #ranged_enemy.Ranged_health = healthcomponent
 #ranged_enemy.Ranged_hitbox = hitboxcomponent
#
 #var Ranged_sprite = ranged_enemy.get_node("AnimatedSprite2D")
#
 #var sample_body = Node2D.new()
#
 #add_child(ranged_enemy)
 #await get_tree().process_frame  # Allow _ready() to execute
#
 #ranged_enemy._on_detection_area_body_entered(sample_body)
 #ranged_enemy.shoot_projectile()
#
 #ranged_enemy.queue_free()
 #healthcomponent.queue_free()
 #hitboxcomponent.queue_free()
 #sample_body.queue_free()

func test_ranged_enemy_alive():

 var ranged_enemy_scene = load(RANGED_ENEMY_SCENE)
 var hitboxcomponent_scene = load(HITBOXCOMPONENT_SCENE)
 var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 var ranged_enemy = ranged_enemy_scene.instantiate()
 var healthcomponent = healthcomponent_scene.instantiate()
 var hitboxcomponent = hitboxcomponent_scene.instantiate()

 hitboxcomponent.Health = healthcomponent
 hitboxcomponent.Health._ready()

 ranged_enemy.Ranged_health = healthcomponent
 ranged_enemy.Ranged_hitbox = hitboxcomponent

 var Ranged_sprite = ranged_enemy.get_node("AnimatedSprite2D")

 add_child(ranged_enemy)
 await get_tree().process_frame  # Allow _ready() to execute

 assert_bool(ranged_enemy.is_dead()).is_false()

 ranged_enemy.queue_free()
 healthcomponent.queue_free()
 hitboxcomponent.queue_free()

func test_ranged_enemy_dead_detect():

 var ranged_enemy_scene = load(RANGED_ENEMY_SCENE)
 var hitboxcomponent_scene = load(HITBOXCOMPONENT_SCENE)
 var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 var ranged_enemy = ranged_enemy_scene.instantiate()
 var healthcomponent = healthcomponent_scene.instantiate()
 var hitboxcomponent = hitboxcomponent_scene.instantiate()

 hitboxcomponent.Health = healthcomponent
 hitboxcomponent.Health._ready()

 ranged_enemy.Ranged_health = healthcomponent
 ranged_enemy.Ranged_hitbox = hitboxcomponent

 var Ranged_sprite = ranged_enemy.get_node("AnimatedSprite2D")

 add_child(ranged_enemy)
 await get_tree().process_frame  # Allow _ready() to execute

 ranged_enemy.Ranged_health.take_damage(100)
 assert_bool(ranged_enemy.is_dead()).is_true()

 ranged_enemy.queue_free()
 healthcomponent.queue_free()
 hitboxcomponent.queue_free()

func test_ranged_enemy_dead():

 var ranged_enemy_scene = load(RANGED_ENEMY_SCENE)
 var hitboxcomponent_scene = load(HITBOXCOMPONENT_SCENE)
 var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 var ranged_enemy = ranged_enemy_scene.instantiate()
 var healthcomponent = healthcomponent_scene.instantiate()
 var hitboxcomponent = hitboxcomponent_scene.instantiate()

 hitboxcomponent.Health = healthcomponent
 hitboxcomponent.Health._ready()

 ranged_enemy.Ranged_health = healthcomponent
 ranged_enemy.Ranged_hitbox = hitboxcomponent

 var Ranged_sprite = ranged_enemy.get_node("AnimatedSprite2D")

 add_child(ranged_enemy)
 await get_tree().process_frame  # Allow _ready() to execute

 ranged_enemy.Ranged_health.take_damage(100)
 ranged_enemy.enemy_dead()

 assert_bool(ranged_enemy.Ranged_hitbox.monitoring).is_false()

 ranged_enemy.queue_free()
 healthcomponent.queue_free()
 hitboxcomponent.queue_free()
