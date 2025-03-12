class_name projectile_UnitTest
extends GdUnitTestSuite

const PROJECTILE_SCENE = "res://Scenes/Templates/Projectile.tscn"
const HURTBOX_SCENE = "res://Scenes/Components/hurtbox_component.tscn" # Update with correct path
const hitboxComponent_Test = preload("res://Scripts/Components/HitboxComponent.gd")
const healthComponent_Test = preload("res://Scripts/Components/HealthComponent.gd")

func test_projectile_ready():
 var projectile_scene = load(PROJECTILE_SCENE)
 var hurtbox_scene = load(HURTBOX_SCENE)

 var health_component = healthComponent_Test.new()
 var hitbox_component = hitboxComponent_Test.new()
 var sample_sound = AudioStreamPlayer2D.new()

 sample_sound.name = "AudioStreamPlayer2D"

 var hurtbox = hurtbox_scene.instantiate()
 var projectile = projectile_scene.instantiate()

 health_component._ready()

 hitbox_component.health_component = health_component
 hitbox_component.interaction_sound = sample_sound

 hurtbox.add_child(hitbox_component)
 projectile.add_child(hurtbox)

 add_child(projectile)
 await get_tree().process_frame

 assert_int(projectile.speed).is_equal(100)

 health_component.queue_free()
 sample_sound.queue_free()
 projectile.queue_free()

func test_projectile_fire_player():
 var projectile_scene = load(PROJECTILE_SCENE)
 var hurtbox_scene = load(HURTBOX_SCENE)

 var health_component = healthComponent_Test.new()
 var hitbox_component = hitboxComponent_Test.new()
 var sample_sound = AudioStreamPlayer2D.new()

 sample_sound.name = "AudioStreamPlayer2D"

 var hurtbox = hurtbox_scene.instantiate()
 var projectile = projectile_scene.instantiate()

 health_component._ready()

 hitbox_component.health_component = health_component
 hitbox_component.interaction_sound = sample_sound

 hurtbox.add_child(hitbox_component)
 projectile.add_child(hurtbox)

 projectile.fired_by = "player"

 add_child(projectile)
 await get_tree().process_frame

 assert_int(projectile.speed).is_equal(200)

 health_component.queue_free()
 sample_sound.queue_free()
 projectile.queue_free()


func test_projectile_fire_enemy():
 var projectile_scene = load(PROJECTILE_SCENE)
 var hurtbox_scene = load(HURTBOX_SCENE)

 var health_component = healthComponent_Test.new()
 var hitbox_component = hitboxComponent_Test.new()
 var sample_sound = AudioStreamPlayer2D.new()

 sample_sound.name = "AudioStreamPlayer2D"

 var hurtbox = hurtbox_scene.instantiate()
 var projectile = projectile_scene.instantiate()

 health_component._ready()

 hitbox_component.health_component = health_component
 hitbox_component.interaction_sound = sample_sound

 hurtbox.add_child(hitbox_component)
 projectile.add_child(hurtbox)

 projectile.fired_by = "enemy"

 add_child(projectile)
 await get_tree().process_frame

 assert_int(projectile.speed).is_equal(100)

 health_component.queue_free()
 sample_sound.queue_free()
 projectile.queue_free()

func test_projectile_bounce():
 var projectile_scene = load(PROJECTILE_SCENE)
 var hurtbox_scene = load(HURTBOX_SCENE)

 var health_component = healthComponent_Test.new()
 var hitbox_component = hitboxComponent_Test.new()
 var sample_sound = AudioStreamPlayer2D.new()
 var sample_vector = Vector2(6.0, 9.0)

 sample_sound.name = "AudioStreamPlayer2D"

 var hurtbox = hurtbox_scene.instantiate()
 var projectile = projectile_scene.instantiate()

 health_component._ready()

 hitbox_component.health_component = health_component
 hitbox_component.interaction_sound = sample_sound

 hurtbox.add_child(hitbox_component)
 projectile.add_child(hurtbox)

 projectile.fired_by = "player"

 add_child(projectile)
 await get_tree().process_frame

 projectile.bounce(sample_vector)
 projectile.bounce(sample_vector)
 projectile.bounce(sample_vector)
 projectile.bounce(sample_vector)

 assert_int(projectile.bounce_count).is_equal(4)

 health_component.queue_free()
 sample_sound.queue_free()
 projectile.queue_free()
