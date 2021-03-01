extends Control


func _ready():
	
	
	pass

func _on_OptionButton_item_selected(id):
	match id:
		0:
			OS.set_window_size(Vector2(640, 360))
			OS.center_window()
		1:
			OS.set_window_size(Vector2(960, 540))
			OS.center_window()
		2:
			OS.set_window_size(Vector2(1024, 576))
			OS.center_window()
		3:
			OS.set_window_size(Vector2(1366, 768))
			OS.center_window()
		4:
			OS.set_window_size(Vector2(1600, 900))
			OS.center_window()

func _on_fullscreen_toggled(button_pressed):
	if button_pressed == true:
		OS.window_fullscreen = true
	else:
		OS.window_fullscreen = false


func _on_NewButton_pressed():
	get_tree().change_scene("res://data/scenes/StartGame.tscn")

func _on_back_pressed():
	queue_free()

func _on_exit_pressed():
	get_tree().change_scene("res://data/scenes/StartGame.tscn")

func _on_exit_mouse_entered():
	$exit/TextureRect.texture = load("res://data/pauseMenu/exitS.png")

func _on_exit_mouse_exited():
	$exit/TextureRect.texture = load("res://data/pauseMenu/exit.png")

func _on_back_mouse_entered():
	$back/TextureRect.texture = load("res://data/pauseMenu/resumeS.png")

func _on_back_mouse_exited():
	$back/TextureRect.texture = load("res://data/pauseMenu/resume.png")

func _on_exit_button_down():
	$ButtonAudio.playing = true

func _on_back_button_down():
	$ButtonAudio.playing = true
