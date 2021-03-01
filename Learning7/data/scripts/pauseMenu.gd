extends Control


func _on_Resume_pressed():
	queue_free()
	get_tree().paused = false

func _on_Exit_pressed():
	get_tree().change_scene("res://data/scenes/StartGame.tscn")
	get_tree().paused = false

func _on_Settings_pressed():
	var popup = load("res://data/scenes/settingsMenu.tscn")
	var popupIns = popup.instance()
	add_child(popupIns)

func _on_Settings_mouse_entered():
	$Menu/HBoxContainer/Buttons/Settings/TextureRect.texture = load("res://data/pauseMenu/optionsS.png")

func _on_Settings_mouse_exited():
	$Menu/HBoxContainer/Buttons/Settings/TextureRect.texture = load("res://data/pauseMenu/options.png")

func _on_Resume_mouse_entered():
	$Menu/HBoxContainer/Buttons/Resume/TextureRect.texture = load("res://data/pauseMenu/resumeS.png")

func _on_Resume_mouse_exited():
	$Menu/HBoxContainer/Buttons/Resume/TextureRect.texture = load("res://data/pauseMenu/resume.png")

func _on_Exit_mouse_entered():
	$Menu/HBoxContainer/Buttons/Exit/TextureRect.texture = load("res://data/pauseMenu/exitS.png")

func _on_Exit_mouse_exited():
		$Menu/HBoxContainer/Buttons/Exit/TextureRect.texture = load("res://data/pauseMenu/exit.png")
