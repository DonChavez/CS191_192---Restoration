extends CanvasLayer

@export var loading_screens_path: String = "res://Art/LoadingScreens/"
@export var fade_duration: float = 1.0

var transition_callback: Callable = Callable()
var loading_images: Array[Texture2D] = []

func _ready() -> void:
	preload_loading_images()
	hide()

func preload_loading_images() -> void:
	var dir = DirAccess.open(loading_screens_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name:
			if file_name.ends_with(".png") or file_name.ends_with(".jpg"):
				var image_path = loading_screens_path + file_name
				if ResourceLoader.exists(image_path):
					var texture = load(image_path) as Texture2D
					if texture:
						loading_images.append(texture)
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		push_error("Failed to open directory: %s" % loading_screens_path)

func play_transition(callback: Callable = Callable()) -> void:
	transition_callback = callback  # Store the callback

	# Ensure the loading screen is displayed only once before transition starts
	display_random_loading_screen()

	show()

	# Fade in first
	$TransitionAnimation.play("fade_in")
	await $TransitionAnimation.animation_finished
	
	await get_tree().create_timer(0.5).timeout

	# Call the stored callback before fading out
	if transition_callback.is_valid():
		transition_callback.call()
	
	# Fade out transition
	$TransitionAnimation.play("fade_out")
	await $TransitionAnimation.animation_finished

	hide()

func display_random_loading_screen() -> void:
	if loading_images.size() > 0:
		var random_index = randi() % loading_images.size()
		$LoadingScreen.texture = loading_images[random_index]
	else:
		$LoadingScreen.texture = null
