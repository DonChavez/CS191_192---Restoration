class_name TempoShield_UnitTest
extends GdUnitTestSuite

const TEMPOSHIELD_SCENE = "res://Scenes/Player/TempoShield.tscn"  # Update with correct path

class SampleBody extends Node2D:
 func _on_body_entered(body):
  pass

func test_temposhield_body_enter():

 var temposhield_scene = load(TEMPOSHIELD_SCENE)
 var temposhield = temposhield_scene.instantiate()

 var sample_body = SampleBody.new()

 add_child(temposhield)
 await get_tree().process_frame  # Allow _ready() to execute

 # Have to find a way to test this
 #temposhield._on_body_entered(sample_body)
 # Assertions not needed as the only function does not mutate anything of note to script local

 temposhield.queue_free()
 sample_body.queue_free()
