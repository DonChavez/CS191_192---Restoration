class_name Projectile_UnitTest
extends GdUnitTestSuite


const PROJECTILE_SCENE = "res://Scenes/Objects/Projectile.tscn"  # Update with correct path
const HITBOXCOMPONENT_SCENE = "res://Scenes/Components/HitboxComponent.tscn"  # Update with correct path
const HURTBOXCOMPONENT_SCENE = "res://Scenes/Components/HurtboxComponent.tscn"
const HEALTHCOMPONENT_SCENE = "res://Scenes/Components/HealthComponent.tscn"
const PLAYER_SCENE = "res://Scenes/Player/Player.tscn"
const ENEMY_SCENE = "res://Scenes/Enemies/RangedEnemy.tscn"

func test_projectile_ready():

 var projectile_scene = load(PROJECTILE_SCENE)
 var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 var hurtboxcomponent_scene = load(HURTBOXCOMPONENT_SCENE)
 var hitboxcomponent_scene = load(HITBOXCOMPONENT_SCENE)
 var projectile = projectile_scene.instantiate()
 var hitboxcomponent = hitboxcomponent_scene.instantiate()
 var hurtboxcomponent = hurtboxcomponent_scene.instantiate()
 var healthcomponent = healthcomponent_scene.instantiate()

 hitboxcomponent.Health = healthcomponent
 hitboxcomponent.Health._ready()

 projectile.ProjectileHurtbox = hurtboxcomponent

 var ProjectileHurtbox = projectile.get_node("ProjectileHurtbox")
 
 projectile.SpawnPos = Vector2(1.1, 1.1)
 add_child(projectile)
 await get_tree().process_frame  # Allow _ready() to execute

 assert_vector(projectile.global_position).is_equal(Vector2(1.1, 1.1))

 projectile.queue_free()
 hurtboxcomponent.queue_free()
 healthcomponent.queue_free()
 hitboxcomponent.queue_free()


func test_projectile_redirect_random():

 var projectile_scene = load(PROJECTILE_SCENE)
 var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 var hurtboxcomponent_scene = load(HURTBOXCOMPONENT_SCENE)
 var hitboxcomponent_scene = load(HITBOXCOMPONENT_SCENE)
 var projectile = projectile_scene.instantiate()
 var hitboxcomponent = hitboxcomponent_scene.instantiate()
 var hurtboxcomponent = hurtboxcomponent_scene.instantiate()
 var healthcomponent = healthcomponent_scene.instantiate()

 hitboxcomponent.Health = healthcomponent
 hitboxcomponent.Health._ready()

 projectile.ProjectileHurtbox = hurtboxcomponent

 var ProjectileHurtbox = projectile.get_node("ProjectileHurtbox")
 
 projectile.SpawnPos = Vector2(1.1, 1.1)
 add_child(projectile)
 await get_tree().process_frame  # Allow _ready() to execute

 projectile.redirect_random()
 assert_int(projectile.bounce_count).is_equal(1)

 projectile.queue_free()
 hurtboxcomponent.queue_free()
 healthcomponent.queue_free()
 hitboxcomponent.queue_free()


# IN PROGRESS
#func test_projectile_player_fire():
#
 #var projectile_scene = load(PROJECTILE_SCENE)
 #var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 #var hurtboxcomponent_scene = load(HURTBOXCOMPONENT_SCENE)
 #var hitboxcomponent_scene = load(HITBOXCOMPONENT_SCENE)
 #var player_scene = load(PLAYER_SCENE)
 #var projectile = projectile_scene.instantiate()
 #var hitboxcomponent = hitboxcomponent_scene.instantiate()
 #var hurtboxcomponent = hurtboxcomponent_scene.instantiate()
 #var healthcomponent = healthcomponent_scene.instantiate()
 #var player = player_scene.instantiate()
#
 #hitboxcomponent.Health = healthcomponent
 #hitboxcomponent.Health._ready()
#
 #projectile.ProjectileHurtbox = hurtboxcomponent
#
 #var ProjectileHurtbox = projectile.get_node("ProjectileHurtbox")
 #
 #projectile.SpawnPos = Vector2(1.1, 1.1)
#
 #var sample_name = player.get_node("Projectile")
#
 #add_child(projectile)
 #await get_tree().process_frame  # Allow _ready() to execute
#
 #projectile.fireblaster(sample_name)
#
 #assert_int(projectile.Speed).is_equal(200)
#
 #projectile.queue_free()
 #player.queue_free()
 #hurtboxcomponent.queue_free()
 #healthcomponent.queue_free()
 #hitboxcomponent.queue_free()


# Still figuring out the in_group system for testing
# Might have to use Canvas Group
# Same problem with Player Manage dependency, might have to use Scene Runner or find a way
# Above problems apply to the methods not tested here
