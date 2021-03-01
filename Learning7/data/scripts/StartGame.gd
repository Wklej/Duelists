extends Control


func _ready():
	pass

func _on_StartButton_pressed():
	get_tree().change_scene("res://data/worlds/world2.tscn")

func _on_StartButton_button_down():
	$ButtonAudio.play()

func _on_StartButton_button_up():
	$Menu/HBoxContainer/Buttons/StartButton/TextureRect.texture = load("res://data/menu/play.png")

func _on_Settings_button_down():
	$Menu/HBoxContainer/Buttons/Settings/TextureRect.texture = load("res://data/menu/optionsCursor.png")
	$ButtonAudio.playing = true

func _on_Settings_button_up():
	$Menu/HBoxContainer/Buttons/Settings/TextureRect.texture = load("res://data/menu/options.png")

func _on_Exit_pressed():
	get_tree().quit()

func _on_Exit_button_down():
	$Menu/HBoxContainer/Buttons/Exit/TextureRect.texture = load("res://data/menu/exitCursor.png")

func _on_Tutorial_pressed():
	get_tree().change_scene("res://data/worlds/ComputerWorlds/worldC2.tscn")

func _on_Settings_pressed():
	var popup = load("res://data/scenes/settingsMenu.tscn")
	var popupIns = popup.instance()
	add_child(popupIns)

func _on_StartButton_mouse_entered():
	$Menu/HBoxContainer/Buttons/StartButton/TextureRect.texture = load("res://data/menu/playCursor.png")

func _on_StartButton_mouse_exited():
	$Menu/HBoxContainer/Buttons/StartButton/TextureRect.texture = load("res://data/menu/play.png")

func _on_Settings_mouse_entered():
	$Menu/HBoxContainer/Buttons/Settings/TextureRect.texture = load("res://data/menu/optionsCursor.png")

func _on_Settings_mouse_exited():
	$Menu/HBoxContainer/Buttons/Settings/TextureRect.texture = load("res://data/menu/options.png")

func _on_Tutorial_mouse_entered():
	$Menu/HBoxContainer/Buttons/Tutorial/TextureRect.texture = load("res://data/menu/vsComputerCursor.png")

func _on_Tutorial_mouse_exited():
	$Menu/HBoxContainer/Buttons/Tutorial/TextureRect.texture = load("res://data/menu/vsComputer.png")

func _on_Exit_mouse_entered():
	$Menu/HBoxContainer/Buttons/Exit/TextureRect.texture = load("res://data/menu/exitCursor.png")

func _on_Exit_mouse_exited():
	$Menu/HBoxContainer/Buttons/Exit/TextureRect.texture = load("res://data/menu/exit.png")

func _on_Tutorial_button_down():
	$ButtonAudio.playing = true
