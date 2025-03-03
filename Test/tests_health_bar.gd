class_name health_bar_UnitTest
extends GdUnitTestSuite

const HealthComponentTest = preload("res://Scripts/Components/HealthComponent.gd")
const health_barTest = preload("res://Scripts/health_bar.gd")


func test_Healthbar_init() -> void:
 var health_component =  HealthComponentTest.new()
 var health_bar = health_barTest.new()

 health_component._ready()
 health_bar.health_component = health_component
 health_bar._ready()
 assert_float(health_bar.health_component.health).is_equal(100.0)
 health_component.queue_free()
 health_bar.queue_free()


func test_Healthbar_change_health() -> void:
 var health_component =  HealthComponentTest.new()
 var health_bar = health_barTest.new()
 health_component._ready()
 health_bar.health_component = health_component
 health_bar._ready()
 health_bar.health_component.take_damage(40.0) 
 assert_float(health_bar.health_component.health).is_equal(60.0)
 health_component.queue_free()
 health_bar.queue_free()


# No need for scene tests, only logic needed
