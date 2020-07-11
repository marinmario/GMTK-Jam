extends Node2D

var mouse_over := false
var follow_mouse := false
var placed := false
var cell: Area2D
var type := "CellObject"
onready var initial_position := global_position

func _ready() -> void:
	$Objects.play(type)
	match type:
		"Turret":
			$TurretBulletTimer.start()
		"OilWell":
			$CoinTimer.start()

func _process(delta: float) -> void:
	if mouse_over and not placed:
		if Input.is_action_just_pressed("drag"):
			follow_mouse = true
		if Input.is_action_just_released("drag"):
			follow_mouse = false
			if cell != null:
				global_position = cell.get_node("Pivot").global_position
				placed = true
			else:
				global_position = initial_position
	
	if follow_mouse:
		global_position = get_global_mouse_position()

func _on_MouseArea_area_entered(area: Area2D) -> void:
	if area.is_in_group("cells"):
		cell = area

func _on_MouseArea_mouse_entered() -> void:
	mouse_over = true

func _on_MouseArea_mouse_exited() -> void:
	mouse_over = false

func shoot() -> void:
	var bullet: Area2D = Global.TURRET_BULLET.instance()
	bullet.global_position = global_position
	get_parent().add_child(bullet)

func spawn_coin() -> void:
	randomize()
	var coin: Area2D = Global.COIN.instance()
	coin.global_position = global_position + Vector2(rand_range(-50, 50), rand_range(-50, 50))
	get_parent().add_child(coin)

func _on_TurretBulletTimer_timeout():
	if placed: shoot()

func _on_CoinTimer_timeout():
	if placed: spawn_coin()
