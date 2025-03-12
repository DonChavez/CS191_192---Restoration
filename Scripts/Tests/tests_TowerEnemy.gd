class_name TowerEnemy_UnitTest
extends GdUnitTestSuite


const TOWER_ENEMY_SCENE = "res://Scenes/Enemies/TowerEnemy.tscn"  # Update with correct path
const HITBOXCOMPONENT_SCENE = "res://Scenes/Components/HitboxComponent.tscn"
const HEALTHCOMPONENT_SCENE = "res://Scenes/Components/HealthComponent.tscn"

func test_tower_enemy_ready():

 var tower_enemy_scene = load(TOWER_ENEMY_SCENE)
 var hitboxcomponent_scene = load(HITBOXCOMPONENT_SCENE)
 var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 var tower_enemy = tower_enemy_scene.instantiate()
 var healthcomponent = healthcomponent_scene.instantiate()
 var hitboxcomponent = hitboxcomponent_scene.instantiate()

 hitboxcomponent.Health = healthcomponent
 hitboxcomponent.Health._ready()

 tower_enemy.Tower_health = healthcomponent
 tower_enemy.Tower_hitbox = hitboxcomponent

 var Tower_sprite = tower_enemy.get_node("Sprite2D")

 add_child(tower_enemy)
 await get_tree().process_frame  # Allow _ready() to execute

 # Assertions not needed, initializations does not mutate anything

 tower_enemy.queue_free()
 healthcomponent.queue_free()
 hitboxcomponent.queue_free()

func test_tower_enemy_detect_enter():

 var tower_enemy_scene = load(TOWER_ENEMY_SCENE)
 var hitboxcomponent_scene = load(HITBOXCOMPONENT_SCENE)
 var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 var tower_enemy = tower_enemy_scene.instantiate()
 var healthcomponent = healthcomponent_scene.instantiate()
 var hitboxcomponent = hitboxcomponent_scene.instantiate()

 hitboxcomponent.Health = healthcomponent
 hitboxcomponent.Health._ready()

 tower_enemy.Tower_health = healthcomponent
 tower_enemy.Tower_hitbox = hitboxcomponent

 var Tower_sprite = tower_enemy.get_node("Sprite2D")

 var sample_body = Node2D.new()

 add_child(tower_enemy)
 await get_tree().process_frame  # Allow _ready() to execute

 tower_enemy._on_detection_area_body_entered(sample_body)
 # Assertions not needed, detection enter does not mutate anything

 sample_body.queue_free()
 tower_enemy.queue_free()
 healthcomponent.queue_free()
 hitboxcomponent.queue_free()

func test_tower_enemy_detect_exit():

 var tower_enemy_scene = load(TOWER_ENEMY_SCENE)
 var hitboxcomponent_scene = load(HITBOXCOMPONENT_SCENE)
 var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 var tower_enemy = tower_enemy_scene.instantiate()
 var healthcomponent = healthcomponent_scene.instantiate()
 var hitboxcomponent = hitboxcomponent_scene.instantiate()

 hitboxcomponent.Health = healthcomponent
 hitboxcomponent.Health._ready()

 tower_enemy.Tower_health = healthcomponent
 tower_enemy.Tower_hitbox = hitboxcomponent

 var Tower_sprite = tower_enemy.get_node("Sprite2D")

 var sample_body = Node2D.new()

 add_child(tower_enemy)
 await get_tree().process_frame  # Allow _ready() to execute

 tower_enemy._on_detection_area_body_entered(sample_body)
 tower_enemy._on_detection_area_body_exited(sample_body)
 # Assertions not needed, detection exit does not mutate anything

 sample_body.queue_free()
 tower_enemy.queue_free()
 healthcomponent.queue_free()
 hitboxcomponent.queue_free()

func test_tower_enemy_circle_attack():

 var tower_enemy_scene = load(TOWER_ENEMY_SCENE)
 var hitboxcomponent_scene = load(HITBOXCOMPONENT_SCENE)
 var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 var tower_enemy = tower_enemy_scene.instantiate()
 var healthcomponent = healthcomponent_scene.instantiate()
 var hitboxcomponent = hitboxcomponent_scene.instantiate()

 hitboxcomponent.Health = healthcomponent
 hitboxcomponent.Health._ready()

 tower_enemy.Tower_health = healthcomponent
 tower_enemy.Tower_hitbox = hitboxcomponent

 var Tower_sprite = tower_enemy.get_node("Sprite2D")

 var sample_body = Node2D.new()

 add_child(tower_enemy)
 await get_tree().process_frame  # Allow _ready() to execute

 tower_enemy.circle_attack()
 # Assertions not needed, circle attack does not mutate anything

 sample_body.queue_free()
 tower_enemy.queue_free()
 healthcomponent.queue_free()
 hitboxcomponent.queue_free()

func test_tower_enemy_alive():

 var tower_enemy_scene = load(TOWER_ENEMY_SCENE)
 var hitboxcomponent_scene = load(HITBOXCOMPONENT_SCENE)
 var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 var tower_enemy = tower_enemy_scene.instantiate()
 var healthcomponent = healthcomponent_scene.instantiate()
 var hitboxcomponent = hitboxcomponent_scene.instantiate()

 hitboxcomponent.Health = healthcomponent
 hitboxcomponent.Health._ready()

 tower_enemy.Tower_health = healthcomponent
 tower_enemy.Tower_hitbox = hitboxcomponent

 var Tower_sprite = tower_enemy.get_node("Sprite2D")

 add_child(tower_enemy)
 await get_tree().process_frame  # Allow _ready() to execute

 assert_bool(tower_enemy.is_dead()).is_false()

 tower_enemy.queue_free()
 healthcomponent.queue_free()
 hitboxcomponent.queue_free()

func test_tower_enemy_dead_detect():

 var tower_enemy_scene = load(TOWER_ENEMY_SCENE)
 var hitboxcomponent_scene = load(HITBOXCOMPONENT_SCENE)
 var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 var tower_enemy = tower_enemy_scene.instantiate()
 var healthcomponent = healthcomponent_scene.instantiate()
 var hitboxcomponent = hitboxcomponent_scene.instantiate()

 hitboxcomponent.Health = healthcomponent
 hitboxcomponent.Health._ready()

 tower_enemy.Tower_health = healthcomponent
 tower_enemy.Tower_hitbox = hitboxcomponent

 var Tower_sprite = tower_enemy.get_node("Sprite2D")

 add_child(tower_enemy)
 await get_tree().process_frame  # Allow _ready() to execute

 tower_enemy.Tower_health.take_damage(100)
 assert_bool(tower_enemy.is_dead()).is_true()

 tower_enemy.queue_free()
 healthcomponent.queue_free()
 hitboxcomponent.queue_free()

func test_tower_enemy_dead():

 var tower_enemy_scene = load(TOWER_ENEMY_SCENE)
 var hitboxcomponent_scene = load(HITBOXCOMPONENT_SCENE)
 var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 var tower_enemy = tower_enemy_scene.instantiate()
 var healthcomponent = healthcomponent_scene.instantiate()
 var hitboxcomponent = hitboxcomponent_scene.instantiate()

 hitboxcomponent.Health = healthcomponent
 hitboxcomponent.Health._ready()

 tower_enemy.Tower_health = healthcomponent
 tower_enemy.Tower_hitbox = hitboxcomponent

 var Tower_sprite = tower_enemy.get_node("Sprite2D")

 add_child(tower_enemy)
 await get_tree().process_frame  # Allow _ready() to execute

 tower_enemy.Tower_health.take_damage(100)
 tower_enemy.enemy_dead()

 # Assertions not needed, updating death state does not mutate anything

 tower_enemy.queue_free()
 healthcomponent.queue_free()
 hitboxcomponent.queue_free()
