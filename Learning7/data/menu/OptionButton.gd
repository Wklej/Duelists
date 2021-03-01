extends OptionButton

func _ready():
	add_item("640 x 360")
	add_item("960 x 540")
	add_item("1024 x 576")
	add_item("1366 × 768")
	add_item("1600 × 900")

func _disabled():
	disabled = true

func _enabled():
	disabled = false


func _on_fullscreen_toggled(button_pressed):
	if button_pressed == true:
		_disabled()
	else:
		_enabled()
