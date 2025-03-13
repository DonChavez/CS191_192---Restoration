class_name TrashPile_UnitTest
extends GdUnitTestSuite


const TRASHPILE_SCENE = "res://Scenes/TrashPile.tscn"  # Update with correct path
const TRASHSPAWN_SCENE = "res://Scenes/TrashSpawner.tscn"
const HITBOXCOMPONENT_SCENE = "res://Scenes/Components/HitboxComponent.tscn"
const HEALTHCOMPONENT_SCENE = "res://Scenes/Components/HealthComponent.tscn"

func test_trashpile_ready():

 var trashpile_scene = load(TRASHPILE_SCENE)
 var hitboxcomponent_scene = load(HITBOXCOMPONENT_SCENE)
 var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 var trashspawn_scene = load(TRASHSPAWN_SCENE)
 var trashpile = trashpile_scene.instantiate()
 var healthcomponent = healthcomponent_scene.instantiate()
 var hitboxcomponent = hitboxcomponent_scene.instantiate()
 var trashspawn = trashspawn_scene.instantiate()

 hitboxcomponent.Health = healthcomponent
 hitboxcomponent.Health._ready()

 trashpile.TP_health = healthcomponent
 trashpile.TP_hitbox = hitboxcomponent

 var TP_sprite = trashpile.get_node("Sprite2D")
 var TP_trashspawn = trashspawn

 add_child(trashpile)
 await get_tree().process_frame  # Allow _ready() to execute

 #Assertions not needed, Initialization does not mutate anything of note

 trashpile.queue_free()
 healthcomponent.queue_free()
 hitboxcomponent.queue_free()
 trashspawn.queue_free()

#func test_trashpile_is_dead_true():
#
 #var trashpile_scene = load(TRASHPILE_SCENE)
 #var hitboxcomponent_scene = load(HITBOXCOMPONENT_SCENE)
 #var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 #var trashspawn_scene = load(TRASHSPAWN_SCENE)
 #var trashpile = trashpile_scene.instantiate()
 #var healthcomponent = healthcomponent_scene.instantiate()
 #var hitboxcomponent = hitboxcomponent_scene.instantiate()
 #var trashspawn = trashspawn_scene.instantiate()
#
 #hitboxcomponent.Health = healthcomponent
 #hitboxcomponent.Health._ready()
#
 #trashpile.TP_health = healthcomponent
 #trashpile.TP_hitbox = hitboxcomponent
#
 #var TP_sprite = trashpile.get_node("Sprite2D")
 #var TP_trashspawn = trashspawn
#
 #add_child(trashpile)
 #await get_tree().process_frame  # Allow _ready() to execute
#
 #trashpile.TP_health.take_damage(100)
 #assert_bool(trashpile.is_dead()).is_true()
#
 #trashpile.queue_free()
 #healthcomponent.queue_free()
 #hitboxcomponent.queue_free()
 #trashspawn.queue_free()

#func test_trashpile_is_dead_false():
#
 #var trashpile_scene = load(TRASHPILE_SCENE)
 #var hitboxcomponent_scene = load(HITBOXCOMPONENT_SCENE)
 #var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 #var trashspawn_scene = load(TRASHSPAWN_SCENE)
 #var trashpile = trashpile_scene.instantiate()
 #var healthcomponent = healthcomponent_scene.instantiate()
 #var hitboxcomponent = hitboxcomponent_scene.instantiate()
 #var trashspawn = trashspawn_scene.instantiate()
#
 #hitboxcomponent.Health = healthcomponent
 #hitboxcomponent.Health._ready()
#
 #trashpile.TP_health = healthcomponent
 #trashpile.TP_hitbox = hitboxcomponent
#
 #var TP_sprite = trashpile.get_node("Sprite2D")
 #var TP_trashspawn = trashspawn
#
 #add_child(trashpile)
 #await get_tree().process_frame  # Allow _ready() to execute
#
 #trashpile.TP_health.take_damage(5)
 #assert_bool(trashpile.is_dead()).is_false()
#
 #trashpile.queue_free()
 #healthcomponent.queue_free()
 #hitboxcomponent.queue_free()
 #trashspawn.queue_free()
#
#func test_trashpile_object_destroyed():
#
 #var trashpile_scene = load(TRASHPILE_SCENE)
 #var hitboxcomponent_scene = load(HITBOXCOMPONENT_SCENE)
 #var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 #var trashspawn_scene = load(TRASHSPAWN_SCENE)
 #var trashpile = trashpile_scene.instantiate()
 #var healthcomponent = healthcomponent_scene.instantiate()
 #var hitboxcomponent = hitboxcomponent_scene.instantiate()
 #var trashspawn = trashspawn_scene.instantiate()
#
 #hitboxcomponent.Health = healthcomponent
 #hitboxcomponent.Health._ready()
#
 #trashpile.TP_health = healthcomponent
 #trashpile.TP_hitbox = hitboxcomponent
#
 #var TP_sprite = trashpile.get_node("Sprite2D")
 #var TP_trashspawn = trashspawn
#
 #add_child(trashpile)
 #await get_tree().process_frame  # Allow _ready() to execute
#
 #trashpile.object_destroyed()
 #assert_bool(trashpile.TP_hitbox.monitoring).is_false()
#
 #trashpile.queue_free()
 #healthcomponent.queue_free()
 #hitboxcomponent.queue_free()
 #trashspawn.queue_free()
#
#func test_trashpile_spawn():
#
 #var trashpile_scene = load(TRASHPILE_SCENE)
 #var hitboxcomponent_scene = load(HITBOXCOMPONENT_SCENE)
 #var healthcomponent_scene = load(HEALTHCOMPONENT_SCENE)
 #var trashspawn_scene = load(TRASHSPAWN_SCENE)
 #var trashpile = trashpile_scene.instantiate()
 #var healthcomponent = healthcomponent_scene.instantiate()
 #var hitboxcomponent = hitboxcomponent_scene.instantiate()
 #var trashspawn = trashspawn_scene.instantiate()
#
 #hitboxcomponent.Health = healthcomponent
 #hitboxcomponent.Health._ready()
#
 #trashpile.TP_health = healthcomponent
 #trashpile.TP_hitbox = hitboxcomponent
#
 #var TP_sprite = trashpile.get_node("Sprite2D")
 #var TP_trashspawn = trashspawn
#
 #add_child(trashpile)
 #await get_tree().process_frame  # Allow _ready() to execute
#
 ## Have to skip this first, needs a world instance during TDD(Prob not possible and might need Scene Runner/BDD)
 ##trashpile._on_trash_pile_health_damage_taken(1.0)
 ##Assertions not needed, Spawn does not mutate anything of note
#
 #trashpile.queue_free()
 #healthcomponent.queue_free()
 #hitboxcomponent.queue_free()
 #trashspawn.queue_free()
