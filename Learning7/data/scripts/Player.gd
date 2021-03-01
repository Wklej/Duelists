extends KinematicBody2D

signal sword_instance
signal arrowPlayer
signal lose
signal loseRound

const UP = Vector2(0, -1)
var GRAVITY = 20;
const MAX_SPEED = 300;
const JUMP_HEIGHT = -600;

var input_vector = Vector2.ZERO
var velocity = Vector2.ZERO

enum{
	MOVE,
	ATAK,
	DEAD,
	KNOCK,
	THROW,
	WITH_SWORD,
	WITHOUT_SWORD,
	WIN_GAME
}

var direction = Vector2(1,0)
var knock_direction = Vector2.ZERO
var state = MOVE

var swordpos = 1; #pozycja szpady
var sword_state = WITH_SWORD; #ze szpada czy bez
onready var animationstate = $AnimationTree.get("parameters/playback")

#Zmiana pozycji szpady
func _input(event):
	if Input.is_key_pressed(KEY_W):
		if(swordpos < 2):
			swordpos += 1;
	if Input.is_key_pressed(KEY_S):
		if(swordpos > 0):
			swordpos -= 1;

func _physics_process(delta):
	velocity.y += GRAVITY;
	
	match sword_state:
		WITH_SWORD:
			match state:
				MOVE:
					move_state()
				ATAK:
					if _CD_timeout() == 0:
						_Atak(swordpos)
					else:
						state = MOVE
				DEAD:
					_Dead()
				KNOCK:
					_Knockback(direction)
				THROW:
					_Throw()
				WIN_GAME:
					$AnimationTree.active = false
					$AnimationPlayer.play("Win")
		WITHOUT_SWORD:
			_hide_Sword()
			match state:
				MOVE:
					move_state()
				DEAD:
					_Dead()
				KNOCK:
					_Knockback(direction)
				WIN_GAME:
					$AnimationTree.active = false
					$AnimationPlayer.play("Win")

func _winGame():
	state = WIN_GAME

func _Atak(pozycja_):
	if is_on_floor():
		match pozycja_:
			0:
				animationstate.travel("HitBotB")
			1:
				animationstate.travel("HitMidB")
			2:
				animationstate.travel("HitHighB")
	_start_CD_timer(1.5)
	state = MOVE


func _Idle(pozycja_):
	match pozycja_:
		0:
			animationstate.travel("IdleBOTB")
		1:
			animationstate.travel("IdleMIDB")
		2:
			animationstate.travel("IdleHIGHB")

func move_state():
	if input_vector.x > 0:
		direction.x = 1;
		_translate_collisionR()
	elif input_vector.x < 0:
		_translate_collisionL()
		direction.x = -1;
	
	_Load_params()
	
	input_vector.x = (Input.get_action_strength("PlayerPrawo") - Input.get_action_strength("PlayerLewo"));
	
	if is_on_floor():
		if Input.is_action_just_pressed("PlayerSkok"):
			velocity.y = JUMP_HEIGHT
		
		if input_vector != Vector2.ZERO:
			animationstate.travel("RUNB")
		else:
			_Idle(swordpos)
	else:
		_Jump()
	
	if sword_state == WITH_SWORD:
		if Input.is_action_just_pressed("PlayerAtak"):
			state = ATAK
		
		if Input.is_action_just_pressed("PlayerRzut"):
			state = THROW
	
	velocity.x = input_vector.x * MAX_SPEED
	velocity = move_and_slide(velocity, UP)

func _Jump():
	if sword_state == WITH_SWORD:
		animationstate.travel("JumpSword")
	else:
		animationstate.travel("JumpNoSword")
		
	if direction.x == 1:
		$PlayerSprite.flip_h = false;
		velocity.x = 200
	else:
		$PlayerSprite.flip_h = true;
		velocity.x = -200

func _Dead():
	$Sword/SwordCollision.disabled = true
	$Sword/Hitbox/CollisionShape2D.disabled = true
	$PlayerHurtBox/CollisionShape2D.disabled = true
	$PlayerCollision.disabled = true
	GRAVITY = 0;
	animationstate.travel("Dead")

func _Throw():
	if is_on_floor() == true:
		animationstate.travel("GroundThrow")
	else:
		animationstate.travel("JumpingThrow")

func _on_PlayerHurtBox_area_entered(area):
	var areaposition = 0
	areaposition = area.get_parent().get_node("SwordPos").global_position
	
	knock_direction = (self.global_position - area.global_position).normalized()
	
	if area.get_parent().get_name() == "SwordRig":
		sword_state = WITH_SWORD
		call_deferred("_show_Sword")
	elif area.get_name() == "Hitbox":
		if area.get_parent().get_name() == "SwordRigE":
			_do_damage(20, areaposition)
		else:
			_do_damage(10, areaposition)

func _do_damage(hit_dmg, area_pos):
		$BlinkTimer.start(0.4)
		$BlinkPlayer.play("Start")
		$Hit.playing = true
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
	hurteffectIns.rotation_degrees = rand_range(0, 360)

func _Knockback(direction_):
	animationstate.travel("GettingHit")
	if velocity.x < 1 && velocity.x > -1:
		state = MOVE
	else:
		velocity.x = lerp(velocity.x, 0, 0.2)
		velocity = move_and_slide(velocity, Vector2(0,-1))

func _on_Stats_no_health():
	state = DEAD
	emit_signal("lose")
	emit_signal("loseRound")

func _emit_sword_instance():
	emit_signal("sword_instance")

func _emit_arrow_signal():
	emit_signal("arrowPlayer")

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

func _hide_Sword():
	$Sword/SwordSprite.visible = false
	$Sword/Hitbox/CollisionShape2D.disabled = true
	$Sword/SwordCollision.disabled = true
	$Sword/SwordDetectionBox/CollisionShape2D.disabled = true

func _show_Sword():
	$Sword/SwordSprite.visible = true
	$Sword/SwordCollision.disabled = false

func _translate_collisionR():
	$PlayerCollision.position.x = -2.6
	$PlayerHurtBox/CollisionShape2D.position.x = -2.6
	$Sword/SwordDetectionBox/CollisionShape2D.position.x = 4.34

func _translate_collisionL():
	$PlayerCollision.position.x = 2.6
	$PlayerHurtBox/CollisionShape2D.position.x = 2.6
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
	
	$SwordsHit.playing = true
	if area.get_parent().get_parent().get_name() == "Enemy":
		state = KNOCK
		velocity.x = 200 * knock_direction.x

func _on_BlinkTimer_timeout():
	$BlinkPlayer.play("Stop")

func _throw_Transition():
	state = MOVE
	sword_state = WITHOUT_SWORD

func _CD_timeout():
	return $CD.time_left

func _start_CD_timer(duration):
	$CD.start(duration)
