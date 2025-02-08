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
