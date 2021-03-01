extends Node2D



func _on_Exit_pressed():
	get_tree().change_scene("res://data/scenes/StartGame.tscn")

func _on_Exit_mouse_entered():
	$Exit/TextureRect.texture = load("res://data/pauseMenu/exitS.png")

func _on_Exit_mouse_exited():
	$Exit/TextureRect.texture = load("res://data/pauseMenu/exit.png")


func _on_Exit_button_down():
	$Audio.playing = true
