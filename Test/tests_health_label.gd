class_name health_label_UnitTest
extends GdUnitTestSuite

const health_label_Test = preload("res://Scripts/health_label.gd")
const healthComponent_Test = preload("res://Scripts/Components/HealthComponent.gd")


func test_health_label_ready():
 #Load and Instantiate Scene
 var health_component =  healthComponent_Test.new()
 var health_label =  health_label_Test.new()
 health_component._ready()
 health_label.health_component = health_component
 health_label._ready()
 assert_float(health_label.health_component.health).is_equal(100.0)
 health_component.queue_free()
 health_label.queue_free()

func test_health_label_update():
 var health_component =  healthComponent_Test.new()
 var health_label =  health_label_Test.new()
 health_component._ready()
 health_label.health_component = health_component
 health_label._ready()
 health_label.health_component.take_damage(70)
 assert_str(health_label.text).is_equal("30 / 100")
 health_component.queue_free()
 health_label.queue_free()
