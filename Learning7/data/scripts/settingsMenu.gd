extends Control


func _on_controls_pressed():
	var popup = load("res://data/menu/ControlScreen.tscn")
	var popupIns = popup.instance()
	add_child(popupIns)

func _on_controls_mouse_entered():
	$controls/TextureRect.texture = load("res://data/menu/settingsMenu/controlsCursor.png")

func _on_controls_mouse_exited():
	$controls/TextureRect.texture = load("res://data/menu/settingsMenu/controls.png")

func _on_display_pressed():
	var disp = load("res://data/menu/resolutions.tscn")
	var dispIns = disp.instance()
	add_child(dispIns)

func _on_display_mouse_entered():
	$display/TextureRect.texture = load("res://data/menu/settingsMenu/displayCursor.png")

func _on_display_mouse_exited():
	$display/TextureRect.texture = load("res://data/menu/settingsMenu/display.png")

func _on_display_button_down():
	$ButtonAudio.playing = true

func _on_controls_button_down():
	$ButtonAudio.playing = true

func _on_Back_pressed():
	queue_free()

func _on_Back_mouse_entered():
	$Back/TextureRect.texture = load("res://data/pauseMenu/resumeS.png")

func _on_Back_mouse_exited():
	$Back/TextureRect.texture = load("res://data/pauseMenu/resume.png")

func _on_Back_button_down():
	$Audio.playing = true
