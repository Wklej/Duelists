extends Control



func _on_Back_pressed():
	queue_free()

func _on_Back_mouse_entered():
	$Back/TextureRect.texture = load("res://data/pauseMenu/resumeS.png")

func _on_Back_mouse_exited():
	$Back/TextureRect.texture = load("res://data/pauseMenu/resume.png")

func _on_Exit_pressed():
	get_tree().change_scene("res://data/scenes/StartGame.tscn")

func _on_Exit_mouse_entered():
	$Exit/TextureRect.texture = load("res://data/pauseMenu/exitS.png")

func _on_Exit_mouse_exited():
	$Exit/TextureRect.texture = load("res://data/pauseMenu/exit.png")

func _on_Back_button_down():
	$Audio.playing = true

func _on_Exit_button_down():
	$Audio.playing = true
