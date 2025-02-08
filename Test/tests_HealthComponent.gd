class_name ExampleUnitTest
extends GdUnitTestSuite

# Preloading resources(For per)
# Note: Should we use const or var for preloads? | I'll use var for now since Components might change
const HealthComponent = preload("res://Scripts/HealthComponent.gd")

# Sample test
func test_example():
 assert(true)

func test_HealthComponent_init() -> void:
 var health_component =  HealthComponent.new()
 health_component._ready()
 assert_float(health_component.health).is_equal(100.0)
 health_component.queue_free()
	
func test_HealthComponent_take_damage() -> void:
 var health_component =  HealthComponent.new()
 health_component._ready()
 health_component.take_damage(10.0)
 assert_float(health_component.health).is_equal(90.0)
 health_component.queue_free()

func test_HealthComponent_take_damage_isAlive() -> void:
 var health_component =  HealthComponent.new()
 health_component._ready()
 health_component.take_damage(90.0)
 assert_float(health_component.health).is_equal(10.0)
 assert_bool(health_component.is_alive()).is_equal(true)
 assert_bool(health_component.is_dead()).is_equal(false)
 health_component.queue_free()

func test_HealthComponent_take_damage_isDead() -> void:
 var health_component =  HealthComponent.new()
 health_component._ready()
 health_component.take_damage(100.0)
 assert_float(health_component.health).is_equal(0.0)
 assert_bool(health_component.is_alive()).is_equal(false)
 assert_bool(health_component.is_dead()).is_equal(true)
 health_component.queue_free()
