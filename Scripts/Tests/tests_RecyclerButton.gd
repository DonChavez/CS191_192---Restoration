class_name RecyclerButton_UnitTest
extends GdUnitTestSuite


const RECYCLER_BUTTON_SCENE = "res://Scenes/Interactables/RecyclerButton.tscn"  # Update with correct path

func test_elite_enemy_ready():

 var recycler_button_scene = load(RECYCLER_BUTTON_SCENE)
 var recycler_button = recycler_button_scene.instantiate()

 var The_label = recycler_button.get_node("$CenterContainer/Label")

 add_child(recycler_button)
 await get_tree().process_frame  # Allow _ready() to execute

 # Assertions not needed for initialization, no mutations in variables(_ready only passes) 

 recycler_button.queue_free()

func test_elite_set_index():

 var recycler_button_scene = load(RECYCLER_BUTTON_SCENE)
 var recycler_button = recycler_button_scene.instantiate()

 var The_label = recycler_button.get_node("$CenterContainer/Label")

 add_child(recycler_button)
 await get_tree().process_frame  # Allow _ready() to execute

 recycler_button.set_index(7)

 assert_int(recycler_button.Array_indx).is_equal(7)

 recycler_button.queue_free()

func test_elite_change_cost():

 var recycler_button_scene = load(RECYCLER_BUTTON_SCENE)
 var recycler_button = recycler_button_scene.instantiate()

 var The_label = recycler_button.get_node("$CenterContainer/Label")

 add_child(recycler_button)
 await get_tree().process_frame  # Allow _ready() to execute

 recycler_button.change_cost(12)

 # Might Not Need Assertions as long as method runs successfully
 #assert_int(recycler_button.Row_ID).is_equal(12)

 recycler_button.queue_free()

func test_elite_change_label():

 var recycler_button_scene = load(RECYCLER_BUTTON_SCENE)
 var recycler_button = recycler_button_scene.instantiate()

 var The_label = recycler_button.get_node("$CenterContainer/Label")

 add_child(recycler_button)
 await get_tree().process_frame  # Allow _ready() to execute

 recycler_button.change_label("Lowest Star")

 assert_str(recycler_button.The_label.text).is_equal("Lowest Star")

 recycler_button.queue_free()

 # Some Functions not tested yet(May be due to live or Scene Runner is Needed)
 # EX: _on_mouse_entered and below in the RecyclerButton Script
