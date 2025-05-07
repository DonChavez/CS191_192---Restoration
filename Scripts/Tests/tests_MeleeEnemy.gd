class_name MeleeEnemy_UnitTest
extends GdUnitTestSuite


const MELEE_ENEMY_SCENE = "res://Scenes/Enemies/MeleeEnemy.tscn"  # Update with correct path
const HITBOXCOMPONENT_SCENE = "res://Scenes/Components/HitboxComponent.tscn"
const HEALTHCOMPONENT_SCENE = "res://Scenes/Components/HealthComponent.tscn"

func test_melee_enemy_ready():

 var melee_enemy_scene = load(MELEE_ENEMY_SCENE)
 var hitboxcomponent_scene = load(HITBOXCOMPONENT_SCENE)
 var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 var melee_enemy = melee_enemy_scene.instantiate()
 var healthcomponent = healthcomponent_scene.instantiate()
 var hitboxcomponent = hitboxcomponent_scene.instantiate()

 hitboxcomponent.Health = healthcomponent
 hitboxcomponent.Health._ready()


 melee_enemy.Melee_health = healthcomponent
 melee_enemy.Melee_hitbox = hitboxcomponent

 var Melee_sprite = melee_enemy.get_node("AnimatedSprite2D")
 var DashTimer = melee_enemy.get_node("Timer")

 add_child(melee_enemy)
 await get_tree().process_frame  # Allow _ready() to execute

 assert_float(melee_enemy.DashTimer.wait_time).is_equal(1.0)
 assert_bool(melee_enemy.DashTimer.one_shot).is_false()

 melee_enemy.queue_free()
 healthcomponent.queue_free()
 hitboxcomponent.queue_free()

#func test_melee_enemy_detect_enter():
#
 #var melee_enemy_scene = load(MELEE_ENEMY_SCENE)
 #var hitboxcomponent_scene = load(HITBOXCOMPONENT_SCENE)
 #var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 #var melee_enemy = melee_enemy_scene.instantiate()
 #var healthcomponent = healthcomponent_scene.instantiate()
 #var hitboxcomponent = hitboxcomponent_scene.instantiate()
#
 #hitboxcomponent.Health = healthcomponent
 #hitboxcomponent.Health._ready()
#
#
 #melee_enemy.Melee_health = healthcomponent
 #melee_enemy.Melee_hitbox = hitboxcomponent
#
 #var Melee_sprite = melee_enemy.get_node("AnimatedSprite2D")
 #var DashTimer = melee_enemy.get_node("Timer")
#
 #var sample_body = Node2D.new()
#
 #add_child(melee_enemy)
 #await get_tree().process_frame  # Allow _ready() to execute
#
 #melee_enemy._on_detection_area_body_entered(sample_body)
 #assert_bool(melee_enemy.Player_chase).is_true()
#
 #melee_enemy.queue_free()
 #healthcomponent.queue_free()
 #hitboxcomponent.queue_free()
 #sample_body.queue_free()

func test_melee_enemy_detect_exit():

 var melee_enemy_scene = load(MELEE_ENEMY_SCENE)
 var hitboxcomponent_scene = load(HITBOXCOMPONENT_SCENE)
 var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 var melee_enemy = melee_enemy_scene.instantiate()
 var healthcomponent = healthcomponent_scene.instantiate()
 var hitboxcomponent = hitboxcomponent_scene.instantiate()

 hitboxcomponent.Health = healthcomponent
 hitboxcomponent.Health._ready()


 melee_enemy.Melee_health = healthcomponent
 melee_enemy.Melee_hitbox = hitboxcomponent

 var Melee_sprite = melee_enemy.get_node("AnimatedSprite2D")
 var DashTimer = melee_enemy.get_node("Timer")

 var sample_body = Node2D.new()

 add_child(melee_enemy)
 await get_tree().process_frame  # Allow _ready() to execute

 melee_enemy._on_detection_area_body_entered(sample_body)
 melee_enemy._on_detection_area_body_exited(sample_body)
 
 assert_bool(melee_enemy.Player_chase).is_false()
 assert_bool(melee_enemy.Dashing).is_false()

 melee_enemy.queue_free()
 healthcomponent.queue_free()
 hitboxcomponent.queue_free()
 sample_body.queue_free()

func test_melee_enemy_alive():

 var melee_enemy_scene = load(MELEE_ENEMY_SCENE)
 var hitboxcomponent_scene = load(HITBOXCOMPONENT_SCENE)
 var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 var melee_enemy = melee_enemy_scene.instantiate()
 var healthcomponent = healthcomponent_scene.instantiate()
 var hitboxcomponent = hitboxcomponent_scene.instantiate()

 hitboxcomponent.Health = healthcomponent
 hitboxcomponent.Health._ready()


 melee_enemy.Melee_health = healthcomponent
 melee_enemy.Melee_hitbox = hitboxcomponent

 var Melee_sprite = melee_enemy.get_node("AnimatedSprite2D")
 var DashTimer = melee_enemy.get_node("Timer")

 add_child(melee_enemy)
 await get_tree().process_frame  # Allow _ready() to execute

 assert_bool(melee_enemy.is_dead()).is_false()

 melee_enemy.queue_free()
 healthcomponent.queue_free()
 hitboxcomponent.queue_free()


func test_melee_enemy_dead_detect():

 var melee_enemy_scene = load(MELEE_ENEMY_SCENE)
 var hitboxcomponent_scene = load(HITBOXCOMPONENT_SCENE)
 var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 var melee_enemy = melee_enemy_scene.instantiate()
 var healthcomponent = healthcomponent_scene.instantiate()
 var hitboxcomponent = hitboxcomponent_scene.instantiate()

 hitboxcomponent.Health = healthcomponent
 hitboxcomponent.Health._ready()


 melee_enemy.Melee_health = healthcomponent
 melee_enemy.Melee_hitbox = hitboxcomponent

 var Melee_sprite = melee_enemy.get_node("AnimatedSprite2D")
 var DashTimer = melee_enemy.get_node("Timer")

 add_child(melee_enemy)
 await get_tree().process_frame  # Allow _ready() to execute

 melee_enemy.Melee_health.take_damage(100)
 assert_bool(melee_enemy.is_dead()).is_true()

 melee_enemy.queue_free()
 healthcomponent.queue_free()
 hitboxcomponent.queue_free()

#func test_melee_enemy_dead():
#
 #var melee_enemy_scene = load(MELEE_ENEMY_SCENE)
 #var hitboxcomponent_scene = load(HITBOXCOMPONENT_SCENE)
 #var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 #var melee_enemy = melee_enemy_scene.instantiate()
 #var healthcomponent = healthcomponent_scene.instantiate()
 #var hitboxcomponent = hitboxcomponent_scene.instantiate()
#
 #hitboxcomponent.Health = healthcomponent
 #hitboxcomponent.Health._ready()
#
#
 #melee_enemy.Melee_health = healthcomponent
 #melee_enemy.Melee_hitbox = hitboxcomponent
#
 #var Melee_sprite = melee_enemy.get_node("AnimatedSprite2D")
 #var DashTimer = melee_enemy.get_node("Timer")
#
 #add_child(melee_enemy)
 #await get_tree().process_frame  # Allow _ready() to execute
#
 #melee_enemy.Melee_health.take_damage(100)
 #melee_enemy.enemy_dead()
#
 #assert_bool(melee_enemy.Melee_hitbox.monitoring).is_false()
#
 #melee_enemy.queue_free()
 #healthcomponent.queue_free()
 #hitboxcomponent.queue_free()
