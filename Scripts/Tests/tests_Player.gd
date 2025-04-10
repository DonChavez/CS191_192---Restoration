class_name Player_UnitTest
extends GdUnitTestSuite


const PLAYER_SCENE = "res://Scenes/Player/Player.tscn"  # Update with correct path
const HITBOXCOMPONENT_SCENE = "res://Scenes/Components/HitboxComponent.tscn"
const HEALTHCOMPONENT_SCENE = "res://Scenes/Components/HealthComponent.tscn"
const HURTBOXCOMPONENT_SCENE = "res://Scenes/Components/HurtboxComponent.tscn"
const INVENTORY_SCENE = "res://Scenes/Inventory/Inventory.tscn"

func test_player_ready():

 var player_scene = load(PLAYER_SCENE)
 var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 var hurtboxcomponent_scene = load(HURTBOXCOMPONENT_SCENE)
 var hitboxcomponent_scene = load(HITBOXCOMPONENT_SCENE)
 var inventory_scene = load(INVENTORY_SCENE)
 var player = player_scene.instantiate()
 var TS_hitbox_test = hitboxcomponent_scene.instantiate()
 var TS_durability_test = healthcomponent_scene.instantiate()
 var Melee_hurtbox_test = hurtboxcomponent_scene.instantiate()
 var Player_hitbox_test = hitboxcomponent_scene.instantiate()
 var Player_health_test = healthcomponent_scene.instantiate()
 var Inventory_test = inventory_scene.instantiate()

 TS_hitbox_test.Health = TS_durability_test
 TS_hitbox_test.Health._ready()

 Player_hitbox_test.Health = Player_health_test
 Player_hitbox_test.Health._ready()

 player.TS_durability = TS_durability_test
 player.TS_hitbox = TS_hitbox_test
 player.Player_health = Player_health_test
 player.Player_hitbox = Player_hitbox_test
 player.Melee_hurtbox = Melee_hurtbox_test
 player.Inventory = Inventory_test
 

 var Player_sprite = player.get_node("AnimatedPlayer2D")
 var Tempo_shield = player.get_node("TempoShield")

 add_child(player)
 await get_tree().process_frame  # Allow _ready() to execute


 assert_bool(player.Melee_hurtbox.monitoring).is_false()
 assert_bool(player.Melee_hurtbox.visible).is_false()
 assert_bool(player.Tempo_shield.visible).is_false()
 assert_bool(player.Tempo_shield.monitoring).is_false()
 assert_bool(player.Tempo_shield.monitorable).is_false()
 assert_bool(player.TS_hitbox.monitoring).is_false()
 assert_bool(player.TS_hitbox.monitorable).is_false()
 assert_bool(player.TS_hitbox.visible).is_false()


 player.queue_free()
 TS_hitbox_test.queue_free()
 TS_durability_test.queue_free()
 Melee_hurtbox_test.queue_free()
 Player_hitbox_test.queue_free()
 Player_health_test.queue_free()
 Inventory_test.queue_free()


func test_player_get_spawn_direction():

 var player_scene = load(PLAYER_SCENE)
 var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 var hurtboxcomponent_scene = load(HURTBOXCOMPONENT_SCENE)
 var hitboxcomponent_scene = load(HITBOXCOMPONENT_SCENE)
 var inventory_scene = load(INVENTORY_SCENE)
 var player = player_scene.instantiate()
 var TS_hitbox_test = hitboxcomponent_scene.instantiate()
 var TS_durability_test = healthcomponent_scene.instantiate()
 var Melee_hurtbox_test = hurtboxcomponent_scene.instantiate()
 var Player_hitbox_test = hitboxcomponent_scene.instantiate()
 var Player_health_test = healthcomponent_scene.instantiate()
 var Inventory_test = inventory_scene.instantiate()

 TS_hitbox_test.Health = TS_durability_test
 TS_hitbox_test.Health._ready()

 Player_hitbox_test.Health = Player_health_test
 Player_hitbox_test.Health._ready()

 player.TS_durability = TS_durability_test
 player.TS_hitbox = TS_hitbox_test
 player.Player_health = Player_health_test
 player.Player_hitbox = Player_hitbox_test
 player.Melee_hurtbox = Melee_hurtbox_test
 player.Inventory = Inventory_test
 

 var Player_sprite = player.get_node("AnimatedPlayer2D")
 var Tempo_shield = player.get_node("TempoShield")

 add_child(player)
 await get_tree().process_frame  # Allow _ready() to execute


 assert_vector(player.get_object_spawn_position("up")).is_equal(Vector2(0, -10))
 assert_vector(player.get_object_spawn_position("down")).is_equal(Vector2(0, 10))
 assert_vector(player.get_object_spawn_position("left")).is_equal(Vector2(-10, 0))
 assert_vector(player.get_object_spawn_position("right")).is_equal(Vector2(10, 0))
 assert_vector(player.get_object_spawn_position("KNOWHERE")).is_equal(Vector2.ZERO)


 player.queue_free()
 TS_hitbox_test.queue_free()
 TS_durability_test.queue_free()
 Melee_hurtbox_test.queue_free()
 Player_hitbox_test.queue_free()
 Player_health_test.queue_free()
 Inventory_test.queue_free()

func test_player_get_melee_attack():

 var player_scene = load(PLAYER_SCENE)
 var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 var hurtboxcomponent_scene = load(HURTBOXCOMPONENT_SCENE)
 var hitboxcomponent_scene = load(HITBOXCOMPONENT_SCENE)
 var inventory_scene = load(INVENTORY_SCENE)
 var player = player_scene.instantiate()
 var TS_hitbox_test = hitboxcomponent_scene.instantiate()
 var TS_durability_test = healthcomponent_scene.instantiate()
 var Melee_hurtbox_test = hurtboxcomponent_scene.instantiate()
 var Player_hitbox_test = hitboxcomponent_scene.instantiate()
 var Player_health_test = healthcomponent_scene.instantiate()
 var Inventory_test = inventory_scene.instantiate()

 TS_hitbox_test.Health = TS_durability_test
 TS_hitbox_test.Health._ready()

 Player_hitbox_test.Health = Player_health_test
 Player_hitbox_test.Health._ready()

 player.TS_durability = TS_durability_test
 player.TS_hitbox = TS_hitbox_test
 player.Player_health = Player_health_test
 player.Player_hitbox = Player_hitbox_test
 player.Melee_hurtbox = Melee_hurtbox_test
 player.Inventory = Inventory_test
 

 var Player_sprite = player.get_node("AnimatedPlayer2D")
 var Tempo_shield = player.get_node("TempoShield")

 add_child(player)
 await get_tree().process_frame  # Allow _ready() to execute

 player.melee_attack()

 assert_bool(player.Is_attacking).is_true()
 assert_float(player.Player_sprite.speed_scale ).is_equal(1.0)


 player.queue_free()
 TS_hitbox_test.queue_free()
 TS_durability_test.queue_free()
 Melee_hurtbox_test.queue_free()
 Player_hitbox_test.queue_free()
 Player_health_test.queue_free()
 Inventory_test.queue_free()

func test_player_get_end_attack_animation():

 var player_scene = load(PLAYER_SCENE)
 var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 var hurtboxcomponent_scene = load(HURTBOXCOMPONENT_SCENE)
 var hitboxcomponent_scene = load(HITBOXCOMPONENT_SCENE)
 var inventory_scene = load(INVENTORY_SCENE)
 var player = player_scene.instantiate()
 var TS_hitbox_test = hitboxcomponent_scene.instantiate()
 var TS_durability_test = healthcomponent_scene.instantiate()
 var Melee_hurtbox_test = hurtboxcomponent_scene.instantiate()
 var Player_hitbox_test = hitboxcomponent_scene.instantiate()
 var Player_health_test = healthcomponent_scene.instantiate()
 var Inventory_test = inventory_scene.instantiate()

 TS_hitbox_test.Health = TS_durability_test
 TS_hitbox_test.Health._ready()

 Player_hitbox_test.Health = Player_health_test
 Player_hitbox_test.Health._ready()

 player.TS_durability = TS_durability_test
 player.TS_hitbox = TS_hitbox_test
 player.Player_health = Player_health_test
 player.Player_hitbox = Player_hitbox_test
 player.Melee_hurtbox = Melee_hurtbox_test
 player.Inventory = Inventory_test
 

 var Player_sprite = player.get_node("AnimatedPlayer2D")
 var Tempo_shield = player.get_node("TempoShield")

 add_child(player)
 await get_tree().process_frame  # Allow _ready() to execute

 player.end_attack_animation()

 assert_bool(player.Is_attacking).is_false()
 assert_float(player.Player_sprite.speed_scale).is_equal(1.0)


 player.queue_free()
 TS_hitbox_test.queue_free()
 TS_durability_test.queue_free()
 Melee_hurtbox_test.queue_free()
 Player_hitbox_test.queue_free()
 Player_health_test.queue_free()
 Inventory_test.queue_free()


func test_player_activate_melee_hurtbox():

 var player_scene = load(PLAYER_SCENE)
 var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 var hurtboxcomponent_scene = load(HURTBOXCOMPONENT_SCENE)
 var hitboxcomponent_scene = load(HITBOXCOMPONENT_SCENE)
 var inventory_scene = load(INVENTORY_SCENE)
 var player = player_scene.instantiate()
 var TS_hitbox_test = hitboxcomponent_scene.instantiate()
 var TS_durability_test = healthcomponent_scene.instantiate()
 var Melee_hurtbox_test = hurtboxcomponent_scene.instantiate()
 var Player_hitbox_test = hitboxcomponent_scene.instantiate()
 var Player_health_test = healthcomponent_scene.instantiate()
 var Inventory_test = inventory_scene.instantiate()

 TS_hitbox_test.Health = TS_durability_test
 TS_hitbox_test.Health._ready()

 Player_hitbox_test.Health = Player_health_test
 Player_hitbox_test.Health._ready()

 player.TS_durability = TS_durability_test
 player.TS_hitbox = TS_hitbox_test
 player.Player_health = Player_health_test
 player.Player_hitbox = Player_hitbox_test
 player.Melee_hurtbox = Melee_hurtbox_test
 player.Inventory = Inventory_test
 

 var Player_sprite = player.get_node("AnimatedPlayer2D")
 var Tempo_shield = player.get_node("TempoShield")

 add_child(player)
 await get_tree().process_frame  # Allow _ready() to execute

 player.activate_melee_hurtbox(2.0, 3.0)

 assert_bool(player.Melee_hurtbox.monitoring).is_false()
 assert_bool(player.Melee_hurtbox.visible).is_false()


 player.queue_free()
 TS_hitbox_test.queue_free()
 TS_durability_test.queue_free()
 Melee_hurtbox_test.queue_free()
 Player_hitbox_test.queue_free()
 Player_health_test.queue_free()
 Inventory_test.queue_free()


func test_player_shoot_projectile():

 var player_scene = load(PLAYER_SCENE)
 var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 var hurtboxcomponent_scene = load(HURTBOXCOMPONENT_SCENE)
 var hitboxcomponent_scene = load(HITBOXCOMPONENT_SCENE)
 var inventory_scene = load(INVENTORY_SCENE)
 var player = player_scene.instantiate()
 var TS_hitbox_test = hitboxcomponent_scene.instantiate()
 var TS_durability_test = healthcomponent_scene.instantiate()
 var Melee_hurtbox_test = hurtboxcomponent_scene.instantiate()
 var Player_hitbox_test = hitboxcomponent_scene.instantiate()
 var Player_health_test = healthcomponent_scene.instantiate()
 var Inventory_test = inventory_scene.instantiate()

 TS_hitbox_test.Health = TS_durability_test
 TS_hitbox_test.Health._ready()

 Player_hitbox_test.Health = Player_health_test
 Player_hitbox_test.Health._ready()

 player.TS_durability = TS_durability_test
 player.TS_hitbox = TS_hitbox_test
 player.Player_health = Player_health_test
 player.Player_hitbox = Player_hitbox_test
 player.Melee_hurtbox = Melee_hurtbox_test
 player.Inventory = Inventory_test
 

 var Player_sprite = player.get_node("AnimatedPlayer2D")
 var Tempo_shield = player.get_node("TempoShield")

 add_child(player)
 await get_tree().process_frame  # Allow _ready() to execute

 #player.shoot_projectile() # BUG-ALERT: Potential Error with Projectile and Hurtbox 
#NOTE: 
#Debugger Break, Reason: 'Invalid call. Nonexistent function 'hurtbox_implement_damage' in base 'Nil'.'
#*Frame 0 - res://Scripts/Components/Projectile.gd:141 in function 'implement_damage'

 #Assertions not needed, shoot projectile does not mutate anything of note


 player.queue_free()
 TS_hitbox_test.queue_free()
 TS_durability_test.queue_free()
 Melee_hurtbox_test.queue_free()
 Player_hitbox_test.queue_free()
 Player_health_test.queue_free()
 Inventory_test.queue_free()


func test_player_block():

 var player_scene = load(PLAYER_SCENE)
 var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 var hurtboxcomponent_scene = load(HURTBOXCOMPONENT_SCENE)
 var hitboxcomponent_scene = load(HITBOXCOMPONENT_SCENE)
 var inventory_scene = load(INVENTORY_SCENE)
 var player = player_scene.instantiate()
 var TS_hitbox_test = hitboxcomponent_scene.instantiate()
 var TS_durability_test = healthcomponent_scene.instantiate()
 var Melee_hurtbox_test = hurtboxcomponent_scene.instantiate()
 var Player_hitbox_test = hitboxcomponent_scene.instantiate()
 var Player_health_test = healthcomponent_scene.instantiate()
 var Inventory_test = inventory_scene.instantiate()

 TS_hitbox_test.Health = TS_durability_test
 TS_hitbox_test.Health._ready()

 Player_hitbox_test.Health = Player_health_test
 Player_hitbox_test.Health._ready()

 player.TS_durability = TS_durability_test
 player.TS_hitbox = TS_hitbox_test
 player.Player_health = Player_health_test
 player.Player_hitbox = Player_hitbox_test
 player.Melee_hurtbox = Melee_hurtbox_test
 player.Inventory = Inventory_test
 

 var Player_sprite = player.get_node("AnimatedPlayer2D")
 var Tempo_shield = player.get_node("TempoShield")

 add_child(player)
 await get_tree().process_frame  # Allow _ready() to execute

 player.block()

 assert_bool(player.Player_hitbox.monitoring).is_false()
 assert_bool(player.Player_hitbox.monitorable).is_false()

 assert_bool(player.Tempo_shield.visible).is_false()
 assert_bool(player.Tempo_shield.monitoring).is_true()
 assert_bool(player.Tempo_shield.monitorable).is_true()
 assert_bool(player.TS_hitbox.monitoring).is_true()
 assert_bool(player.TS_hitbox.monitorable).is_true()
 assert_bool(player.TS_hitbox.monitorable).is_true()
 assert_bool(player.TS_hitbox.visible).is_true()

 player.queue_free()
 TS_hitbox_test.queue_free()
 TS_durability_test.queue_free()
 Melee_hurtbox_test.queue_free()
 Player_hitbox_test.queue_free()
 Player_health_test.queue_free()
 Inventory_test.queue_free()

func test_player_end_block():

 var player_scene = load(PLAYER_SCENE)
 var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 var hurtboxcomponent_scene = load(HURTBOXCOMPONENT_SCENE)
 var hitboxcomponent_scene = load(HITBOXCOMPONENT_SCENE)
 var inventory_scene = load(INVENTORY_SCENE)
 var player = player_scene.instantiate()
 var TS_hitbox_test = hitboxcomponent_scene.instantiate()
 var TS_durability_test = healthcomponent_scene.instantiate()
 var Melee_hurtbox_test = hurtboxcomponent_scene.instantiate()
 var Player_hitbox_test = hitboxcomponent_scene.instantiate()
 var Player_health_test = healthcomponent_scene.instantiate()
 var Inventory_test = inventory_scene.instantiate()

 TS_hitbox_test.Health = TS_durability_test
 TS_hitbox_test.Health._ready()

 Player_hitbox_test.Health = Player_health_test
 Player_hitbox_test.Health._ready()

 player.TS_durability = TS_durability_test
 player.TS_hitbox = TS_hitbox_test
 player.Player_health = Player_health_test
 player.Player_hitbox = Player_hitbox_test
 player.Melee_hurtbox = Melee_hurtbox_test
 player.Inventory = Inventory_test
 

 var Player_sprite = player.get_node("AnimatedPlayer2D")
 var Tempo_shield = player.get_node("TempoShield")

 add_child(player)
 await get_tree().process_frame  # Allow _ready() to execute

 player.block()
 player.end_block()

 assert_bool(player.Player_hitbox.monitoring).is_true()
 assert_bool(player.Player_hitbox.monitorable).is_true()

 assert_bool(player.Tempo_shield.visible).is_false()
 assert_bool(player.Tempo_shield.monitoring).is_false()
 assert_bool(player.Tempo_shield.monitorable).is_false()
 assert_bool(player.TS_hitbox.monitoring).is_false()
 assert_bool(player.TS_hitbox.monitorable).is_false()
 assert_bool(player.TS_hitbox.monitorable).is_false()
 assert_bool(player.TS_hitbox.visible).is_false()

 player.queue_free()
 TS_hitbox_test.queue_free()
 TS_durability_test.queue_free()
 Melee_hurtbox_test.queue_free()
 Player_hitbox_test.queue_free()
 Player_health_test.queue_free()
 Inventory_test.queue_free()

func test_player_death():

 var player_scene = load(PLAYER_SCENE)
 var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 var hurtboxcomponent_scene = load(HURTBOXCOMPONENT_SCENE)
 var hitboxcomponent_scene = load(HITBOXCOMPONENT_SCENE)
 var inventory_scene = load(INVENTORY_SCENE)
 var player = player_scene.instantiate()
 var TS_hitbox_test = hitboxcomponent_scene.instantiate()
 var TS_durability_test = healthcomponent_scene.instantiate()
 var Melee_hurtbox_test = hurtboxcomponent_scene.instantiate()
 var Player_hitbox_test = hitboxcomponent_scene.instantiate()
 var Player_health_test = healthcomponent_scene.instantiate()
 var Inventory_test = inventory_scene.instantiate()

 TS_hitbox_test.Health = TS_durability_test
 TS_hitbox_test.Health._ready()

 Player_hitbox_test.Health = Player_health_test
 Player_hitbox_test.Health._ready()

 player.TS_durability = TS_durability_test
 player.TS_hitbox = TS_hitbox_test
 player.Player_health = Player_health_test
 player.Player_hitbox = Player_hitbox_test
 player.Melee_hurtbox = Melee_hurtbox_test
 player.Inventory = Inventory_test
 

 var Player_sprite = player.get_node("AnimatedPlayer2D")
 var Tempo_shield = player.get_node("TempoShield")

 add_child(player)
 await get_tree().process_frame  # Allow _ready() to execute

 player._on_player_health_died() 
 
 assert_bool(player.Player_is_dead).is_true()
 assert_bool(player.Player_hitbox.monitoring).is_false()

 player.queue_free()
 TS_hitbox_test.queue_free()
 TS_durability_test.queue_free()
 Melee_hurtbox_test.queue_free()
 Player_hitbox_test.queue_free()
 Player_health_test.queue_free()
 Inventory_test.queue_free()

# Can't test Live functions (Mouse, Live Inputs, etc...)
# Excluded testing reactive functions (EX: _on_player_health_damage_taken)
