extends Node


func _on_Player_sword_instance():
	var sword = load("res://data/scenes/SwordRig.tscn")
	var swordIns = sword.instance()
	var players_direction = $Player.direction.x
	add_child(swordIns)
	if players_direction < 0:
		swordIns._rotate()
	swordIns.position = $Player/Sword/SwordPos.global_position
	swordIns.linear_velocity.x = 500 * players_direction

func _on_Enemy_sword_instanceE():
	var sword = load("res://data/scenes/SwordRigE.tscn")
	var swordIns = sword.instance()
	var enemy_direction = $Enemy.direction.x
	add_child(swordIns)
	if enemy_direction < 0:
		swordIns._rotate()
	swordIns.position = $Enemy/Sword/SwordPos.global_position
	swordIns.linear_velocity.x = 500 * enemy_direction

func _input(event):
	if event.is_action_pressed("pause"):
		_pause_game()

func _pause_game():
	get_tree().paused = true
	var popup = load("res://data/scenes/pauseMenu.tscn")
	var popupIns = popup.instance()
	add_child(popupIns)

func _show_arrowR():
	if self.get_name() != "world4":
		var arrow = load("res://data/scenes/Arrow.tscn")
		var arrowIns = arrow.instance()
		add_child(arrowIns)
		arrowIns.position = Vector2(550, 200)
		$RightTeleport.collision_layer = 1

func _show_arrowL():
	if self.get_name() != "world0":
		var arrow = load("res://data/scenes/Arrow.tscn")
		var arrowIns = arrow.instance()
		add_child(arrowIns)
		arrowIns._flip()
		arrowIns.position = Vector2(100, 200)
		$LeftTeleport.collision_layer = 1

func _on_Player_arrowPlayer():
	_show_arrowL()

func _on_Enemy_arrowEnemy():
	_show_arrowR()


func _on_winScreenTimer_timeout():
	if self.get_name() == "world0":
		var winscene = load("res://data/winScreens/yellowPlayerWinScene.tscn")
		var winsceneIns = winscene.instance()
		add_child(winsceneIns)
	elif self.get_name() == "world4":
		var winscene = load("res://data/winScreens/greenPlayerWinScene.tscn")
		var winsceneIns = winscene.instance()
		add_child(winsceneIns)


func _on_Player_lose():
	$winScreenTimer.start(3)
	$Enemy._winGame()


func _on_Enemy_lose():
	$winScreenTimer.start(3)
	$Player._winGame()
