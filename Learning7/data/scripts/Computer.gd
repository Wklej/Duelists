extends KinematicBody2D

signal sword_instanceE
signal lose
signal arrowEnemy

const UP = Vector2(0, -1)
var GRAVITY = 20;
const MAX_SPEED = 300;
const JUMP_HEIGHT = -600;

var input_vector = Vector2.ZERO
var velocity = Vector2.ZERO
var playerdead = 0

enum{
	IDLE,
	ATAK,
	DEAD,
	KNOCK,
	WITH_SWORD,
	CHASE,
	WANDER,
	WIN,
	WIN_GAME
}

var direction = Vector2(1,0)
var knock_direction = Vector2.ZERO
var state = IDLE

var swordpos = 1 #$WanderController.sPosition; #pozycja szpady
onready var animationstate = $AnimationTree.get("parameters/playback")
onready var playerDetectionZone = $PlayerDetectionZone
onready var attackTrigger = $AttackTrigger


#Zmiana pozycji szpady
func _input(event):
	if Input.is_action_just_pressed("EnemySwordPosUp"):
		if(swordpos < 2):
			swordpos += 1;
	if Input.is_action_just_pressed("EnemySwordPosDown"):
		if(swordpos > 0):
			swordpos -= 1;

func _physics_process(delta):
	velocity.y += GRAVITY
	if state != WIN:
		var enemy = get_parent().get_node("Player").global_position
		_update_direction(enemy)
	_Load_params()
	_seek_for_agro()
	
	
	match state:
		IDLE:
			_Idle(swordpos)
		ATAK:
			var player = attackTrigger.player
			
			if player != null:
				if $WanderController.get_CooldownTime_left() == 0:
					_Atak(swordpos)
					$WanderController._start_Ctimer(1.5)
			else:
				state = CHASE
		DEAD:
			_Dead()
		KNOCK:
			_Knockback(direction)
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				accelerate_toward_point(player.global_position)
				animationstate.travel("RUNB")
			else:
				state = IDLE
		WANDER:
			if $WanderController.get_time_left() == 0:
				_update_random_state()
			accelerate_toward_point($WanderController.target_position)
		WIN:
			if self.global_position.x < 300:
				if is_on_floor():
					velocity.y = JUMP_HEIGHT
					_Jump()
			_update_direction(Vector2(0, 300))
			accelerate_toward_point(Vector2(0,300))
		WIN_GAME:
			$AnimationTree.active = false
			$AnimationPlayer.play("Win")

func _winGame():
	state = WIN_GAME

func _winState():
	state = WIN

func _Atak(pozycja_):
	match pozycja_:
		0:
			animationstate.travel("HitBotB")
		1:
			animationstate.travel("HitMidB")
		2:
			animationstate.travel("HitHighB")

func _Idle(pozycja_):
	match pozycja_:
		0:
			animationstate.travel("IdleBOTB")
		1:
			animationstate.travel("IdleMIDB")
		2:
			animationstate.travel("IdleHIGHB")

func move_state():
	
	_seek_for_agro()
	
	#_Load_params()
	
	#input_vector.x = (Input.get_action_strength("EnemyPrawo") - Input.get_action_strength("EnemyLewo"));
	
	if is_on_floor():
		if Input.is_action_just_pressed("EnemySkok"):
			velocity.y = JUMP_HEIGHT
		
		if input_vector != Vector2.ZERO:
			animationstate.travel("RUNB")
		else:
			_Idle(swordpos)
	
	
	velocity.x = input_vector.x * MAX_SPEED
	velocity = move_and_slide(velocity, UP)

func _Jump():
	animationstate.travel("JumpSword")
	
	if direction.x == 1:
		$PlayerSprite.flip_h = false;
		velocity.x = 200
	else:
		$PlayerSprite.flip_h = true;
		velocity.x = -200

func _Dead():
	$Sword/SwordCollision.disabled = true
	$Sword/Hitbox/CollisionShape2D.disabled = true
	$EnemyHurtBox/CollisionShape2D.disabled = true
	$EnemyCollision.disabled = true
	GRAVITY = 0;
	animationstate.travel("Dead")

func _on_PlayerHurtBox_area_entered(area):
	var areaposition = 0
	areaposition = area.get_parent().get_node("SwordPos").global_position
	
	knock_direction = (self.global_position - area.global_position).normalized()
	
	if area.get_name() == "Hitbox":
		if area.get_parent().get_name() == "SwordRig":
			_do_damage(20, areaposition)
		else:
			_do_damage(10, areaposition)

func _do_damage(hit_dmg, area_pos):
		create_HurtEffect(area_pos)
		state = KNOCK
		velocity.x = 200 * knock_direction.x
		$HealthDisplay._update_health(hit_dmg)
		$Stats.health -= hit_dmg

func create_HurtEffect(pos_):
	var hurteffect = load("res://data/scenes/HurtEffect.tscn")
	var hurteffectIns = hurteffect.instance()
	get_parent().add_child(hurteffectIns)
	hurteffectIns.position = pos_

func _Knockback(direction_):
	animationstate.travel("GettingHit")
	if velocity.x < 1 && velocity.x > -1:
		state = IDLE
	else:
		velocity.x = lerp(velocity.x, 0, 0.2)
		velocity = move_and_slide(velocity, Vector2(0,-1))

func _on_Stats_no_health():
	state = DEAD
	emit_signal("lose")

func _emit_sword_instance():
	emit_signal("sword_instanceE")

func _emit_arrow_signal():
	emit_signal("arrowEnemy")

func _Load_params():
	$AnimationTree.set("parameters/JumpSword/blend_position", velocity.normalized())
	$AnimationTree.set("parameters/JumpNoSword/blend_position", velocity.normalized())
	$AnimationTree.set("parameters/RUNB/blend_position", direction)
	$AnimationTree.set("parameters/IdleHIGHB/blend_position", direction)
	$AnimationTree.set("parameters/IdleMIDB/blend_position", direction)
	$AnimationTree.set("parameters/IdleBOTB/blend_position", direction)
	$AnimationTree.set("parameters/HitHighB/blend_position", direction)
	$AnimationTree.set("parameters/HitMidB/blend_position", direction)
	$AnimationTree.set("parameters/HitBotB/blend_position", direction)
	$AnimationTree.set("parameters/GroundThrow/blend_position", direction)
	$AnimationTree.set("parameters/Dying/blend_position", direction)
	$AnimationTree.set("parameters/Dead/blend_position", direction)
	$AnimationTree.set("parameters/GettingHit/blend_position", direction)
	$AnimationTree.set("parameters/JumpingThrow/blend_position", direction)

func _translate_collisionR():
	$EnemyCollision.position.x = -2.6
	$EnemyHurtBox/CollisionShape2D.position.x = -2.6
	$Sword/SwordDetectionBox/CollisionShape2D.position.x = 4.34

func _translate_collisionL():
	$EnemyCollision.position.x = 2.6
	$EnemyHurtBox/CollisionShape2D.position.x = 2.6
	$Sword/SwordDetectionBox/CollisionShape2D.position.x = -4.34

func _enable_sword_col():
	#$Sword/SwordCollision.disabled = false
	$Sword/Hitbox/CollisionShape2D.disabled = false
	$Sword/SwordDetectionBox/CollisionShape2D.disabled = false

func _disable_sword_col():
	#$Sword/SwordCollision.disabled = true
	$Sword/Hitbox/CollisionShape2D.disabled = true
	$Sword/SwordDetectionBox/CollisionShape2D.disabled = true

func _on_SwordDetectionBox_area_entered(area):
	knock_direction = (self.global_position - area.global_position).normalized()
	
	if area.get_parent().get_parent().get_name() == "Player":
		state = KNOCK
		velocity.x = 200 * knock_direction.x

func accelerate_toward_point(point):
	var directionn = (point - self.global_position).normalized()
	velocity.x = directionn.x * MAX_SPEED/3

	if velocity.x > 1 || velocity.x < -1:
		animationstate.travel("RUNB")
	else:
		animationstate.travel("IdleMIDB")
	velocity = move_and_slide(velocity, UP)

func _seek_for_agro():
	if state != DEAD && state != WIN && state != WIN_GAME:
		if attackTrigger._can_see_player():
			state = ATAK
		elif playerDetectionZone.player != null:
			state = CHASE

func _pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func _update_random_state():
	$WanderController.start_wander_timer(rand_range(0.5, 2))
	if $WanderController/Timer.get_time_left() == 0:
		state = _pick_random_state([IDLE, WANDER])

func _update_direction(point): #this point is enemy to the computer(player)
	var directionp = (point - self.global_position).normalized()
	if directionp.x < 0:
		direction.x = -1
		_translate_collisionL()
	else:
		direction.x = 1
		_translate_collisionR()

