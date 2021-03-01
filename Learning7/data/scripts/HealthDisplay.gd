extends Node2D

var bar_red = preload("res://data/sprites/hpBar/redHpBar.png");
var bar_green = preload("res://data/sprites/hpBar/greenHpBar.png");
var bar_yellow = preload("res://data/sprites/hpBar/yellowHpBar.png");
var bar_pink = preload("res://data/sprites/hpBar/pinkHpBar.png");

onready var healthbar = $HealthBar;
onready var healthbar_under = $UnderProgress;
onready var Tween = $Tween;

func _ready():
	if get_parent() and get_parent().get("max_health"):
		healthbar.max_value = get_parent().max_health;


func _process(delta):
	global_rotation = 0;


func _update_health(value):
	healthbar_under.value = healthbar.value;
	healthbar.value -= value
	Tween.interpolate_property(healthbar_under, "value", healthbar_under.value, healthbar_under.value - value, 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	Tween.start()
	
	if healthbar.value < healthbar.max_value * 0.70 && healthbar.value >= healthbar.max_value * 0.30:
		healthbar.texture_progress = bar_yellow;
	elif healthbar.value < healthbar.max_value * 0.30:
		healthbar.texture_progress = bar_red;
	else:
		healthbar.texture_progress = bar_green;

