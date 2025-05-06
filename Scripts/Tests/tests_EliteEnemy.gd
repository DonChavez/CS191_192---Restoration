class_name EliteEnemy_UnitTest
extends GdUnitTestSuite


const ELITE_ENEMY_SCENE = "res://Scenes/Enemies/EliteEnemy.tscn"  # Update with correct path
const HITBOXCOMPONENT_SCENE = "res://Scenes/Components/HitboxComponent.tscn"
const HEALTHCOMPONENT_SCENE = "res://Scenes/Components/HealthComponent.tscn"

func test_elite_enemy_ready():

 var elite_enemy_scene = load(ELITE_ENEMY_SCENE)
 var hitboxcomponent_scene = load(HITBOXCOMPONENT_SCENE)
 var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 var elite_enemy = elite_enemy_scene.instantiate()
 var healthcomponent = healthcomponent_scene.instantiate()
 var hitboxcomponent = hitboxcomponent_scene.instantiate()

 hitboxcomponent.Health = healthcomponent
 hitboxcomponent.Health._ready()

 elite_enemy.Elite_health = healthcomponent
 elite_enemy.Elite_hitbox = hitboxcomponent

 var Elite_sprite = elite_enemy.get_node("AnimatedSprite2D")
 var DashTimer = elite_enemy.get_node("Timer")

 add_child(elite_enemy)
 await get_tree().process_frame  # Allow _ready() to execute

 assert_float(elite_enemy.DashTimer.wait_time).is_equal(1.0)
 assert_bool(elite_enemy.DashTimer.one_shot).is_false()

 elite_enemy.queue_free()
 healthcomponent.queue_free()
 hitboxcomponent.queue_free()

#func test_elite_enemy_detect_enter():
#
 #var elite_enemy_scene = load(ELITE_ENEMY_SCENE)
 #var hitboxcomponent_scene = load(HITBOXCOMPONENT_SCENE)
 #var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 #var elite_enemy = elite_enemy_scene.instantiate()
 #var healthcomponent = healthcomponent_scene.instantiate()
 #var hitboxcomponent = hitboxcomponent_scene.instantiate()
#
 #hitboxcomponent.Health = healthcomponent
 #hitboxcomponent.Health._ready()
#
 #elite_enemy.Elite_health = healthcomponent
 #elite_enemy.Elite_hitbox = hitboxcomponent
#
 #var Elite_sprite = elite_enemy.get_node("AnimatedSprite2D")
 #var DashTimer = elite_enemy.get_node("Timer")
#
 #var sample_body = Node2D.new()
#
 #add_child(elite_enemy)
 #await get_tree().process_frame  # Allow _ready() to execute
#
 #elite_enemy._on_detection_area_body_entered(sample_body)
#
 #assert_bool(elite_enemy.Player_chase).is_true()
#
 #elite_enemy.queue_free()
 #healthcomponent.queue_free()
 #hitboxcomponent.queue_free()
 #sample_body.queue_free()

func test_elite_enemy_detect_exit():

 var elite_enemy_scene = load(ELITE_ENEMY_SCENE)
 var hitboxcomponent_scene = load(HITBOXCOMPONENT_SCENE)
 var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 var elite_enemy = elite_enemy_scene.instantiate()
 var healthcomponent = healthcomponent_scene.instantiate()
 var hitboxcomponent = hitboxcomponent_scene.instantiate()

 hitboxcomponent.Health = healthcomponent
 hitboxcomponent.Health._ready()

 elite_enemy.Elite_health = healthcomponent
 elite_enemy.Elite_hitbox = hitboxcomponent

 var Elite_sprite = elite_enemy.get_node("AnimatedSprite2D")
 var DashTimer = elite_enemy.get_node("Timer")

 var sample_body = Node2D.new()

 add_child(elite_enemy)
 await get_tree().process_frame  # Allow _ready() to execute

 elite_enemy._on_detection_area_body_entered(sample_body)
 elite_enemy._on_detection_area_body_exited(sample_body)

 assert_bool(elite_enemy.Player_chase).is_false()
 assert_bool(elite_enemy.Dashing).is_false()

 elite_enemy.queue_free()
 healthcomponent.queue_free()
 hitboxcomponent.queue_free()
 sample_body.queue_free()

#func test_elite_enemy_shoot_projectile():
#
 #var elite_enemy_scene = load(ELITE_ENEMY_SCENE)
 #var hitboxcomponent_scene = load(HITBOXCOMPONENT_SCENE)
 #var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 #var elite_enemy = elite_enemy_scene.instantiate()
 #var healthcomponent = healthcomponent_scene.instantiate()
 #var hitboxcomponent = hitboxcomponent_scene.instantiate()
#
 #hitboxcomponent.Health = healthcomponent
 #hitboxcomponent.Health._ready()
#
 #elite_enemy.Elite_health = healthcomponent
 #elite_enemy.Elite_hitbox = hitboxcomponent
#
 #var Elite_sprite = elite_enemy.get_node("AnimatedSprite2D")
 #var DashTimer = elite_enemy.get_node("Timer")
#
 #var sample_body = Node2D.new()
#
 #add_child(elite_enemy)
 #await get_tree().process_frame  # Allow _ready() to execute
#
 #elite_enemy._on_detection_area_body_entered(sample_body)
 #elite_enemy.shoot_projectile()
#
 ##Assertions not needed, as long as function returns
 ##test passes(Shooting Projectiles does not mutate anything, but it is a pure local action) 
#
 #elite_enemy.queue_free()
 #healthcomponent.queue_free()
 #hitboxcomponent.queue_free()
 #sample_body.queue_free()

#func test_elite_enemy_circle_attack():
#
 #var elite_enemy_scene = load(ELITE_ENEMY_SCENE)
 #var hitboxcomponent_scene = load(HITBOXCOMPONENT_SCENE)
 #var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 #var elite_enemy = elite_enemy_scene.instantiate()
 #var healthcomponent = healthcomponent_scene.instantiate()
 #var hitboxcomponent = hitboxcomponent_scene.instantiate()
#
 #hitboxcomponent.Health = healthcomponent
 #hitboxcomponent.Health._ready()
#
 #elite_enemy.Elite_health = healthcomponent
 #elite_enemy.Elite_hitbox = hitboxcomponent
#
 #var Elite_sprite = elite_enemy.get_node("AnimatedSprite2D")
 #var DashTimer = elite_enemy.get_node("Timer")
#
 #var sample_body = Node2D.new()
#
 #add_child(elite_enemy)
 #await get_tree().process_frame  # Allow _ready() to execute
#
 #elite_enemy.circle_attack()
#
 ##Assertions not needed, as long as function returns
 ##test passes(Circle Attack does not mutate anything, but it is a pure local action) 
#
 #elite_enemy.queue_free()
 #healthcomponent.queue_free()
 #hitboxcomponent.queue_free()
 #sample_body.queue_free()

func test_elite_enemy_alive():

 var elite_enemy_scene = load(ELITE_ENEMY_SCENE)
 var hitboxcomponent_scene = load(HITBOXCOMPONENT_SCENE)
 var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 var elite_enemy = elite_enemy_scene.instantiate()
 var healthcomponent = healthcomponent_scene.instantiate()
 var hitboxcomponent = hitboxcomponent_scene.instantiate()

 hitboxcomponent.Health = healthcomponent
 hitboxcomponent.Health._ready()

 elite_enemy.Elite_health = healthcomponent
 elite_enemy.Elite_hitbox = hitboxcomponent

 var Elite_sprite = elite_enemy.get_node("AnimatedSprite2D")
 var DashTimer = elite_enemy.get_node("Timer")

 var sample_body = Node2D.new()

 add_child(elite_enemy)
 await get_tree().process_frame  # Allow _ready() to execute

 assert_bool(elite_enemy.is_dead()).is_false()

 elite_enemy.queue_free()
 healthcomponent.queue_free()
 hitboxcomponent.queue_free()
 sample_body.queue_free()

func test_elite_enemy_dead_detect():

 var elite_enemy_scene = load(ELITE_ENEMY_SCENE)
 var hitboxcomponent_scene = load(HITBOXCOMPONENT_SCENE)
 var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 var elite_enemy = elite_enemy_scene.instantiate()
 var healthcomponent = healthcomponent_scene.instantiate()
 var hitboxcomponent = hitboxcomponent_scene.instantiate()

 hitboxcomponent.Health = healthcomponent
 hitboxcomponent.Health._ready()

 elite_enemy.Elite_health = healthcomponent
 elite_enemy.Elite_hitbox = hitboxcomponent

 var Elite_sprite = elite_enemy.get_node("AnimatedSprite2D")
 var DashTimer = elite_enemy.get_node("Timer")

 var sample_body = Node2D.new()

 add_child(elite_enemy)
 await get_tree().process_frame  # Allow _ready() to execute

 elite_enemy.Elite_health.take_damage(500)
 assert_bool(elite_enemy.is_dead()).is_true()

 elite_enemy.queue_free()
 healthcomponent.queue_free()
 hitboxcomponent.queue_free()
 sample_body.queue_free()


func test_elite_enemy_dead():

 var elite_enemy_scene = load(ELITE_ENEMY_SCENE)
 var hitboxcomponent_scene = load(HITBOXCOMPONENT_SCENE)
 var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 var elite_enemy = elite_enemy_scene.instantiate()
 var healthcomponent = healthcomponent_scene.instantiate()
 var hitboxcomponent = hitboxcomponent_scene.instantiate()

 hitboxcomponent.Health = healthcomponent
 hitboxcomponent.Health._ready()

 elite_enemy.Elite_health = healthcomponent
 elite_enemy.Elite_hitbox = hitboxcomponent

 var Elite_sprite = elite_enemy.get_node("AnimatedSprite2D")
 var DashTimer = elite_enemy.get_node("Timer")

 var sample_body = Node2D.new()

 add_child(elite_enemy)
 await get_tree().process_frame  # Allow _ready() to execute

 elite_enemy.Elite_health.take_damage(500)
 elite_enemy.enemy_dead()

 assert_bool(elite_enemy.Elite_hitbox.monitoring).is_false()


 elite_enemy.queue_free()
 healthcomponent.queue_free()
 hitboxcomponent.queue_free()
 sample_body.queue_free()


# Skip _on_dash_timer_timeout() --> For SceneRunner/BDD
# Note: For actions requiring sequencing(Shoot Projectiles, Specified Attacks)
# Only BDD can actually determine the correctness of these. TDD can only reach
# 
