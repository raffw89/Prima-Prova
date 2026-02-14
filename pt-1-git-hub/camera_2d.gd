extends Camera2D

@export var velocita_movimento := 600.0
@export var zoom_velocita := 0.1
@export var zoom_min := 0.5
@export var zoom_max := 4.0

func _process(delta):
	var direzione = Vector2.ZERO
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT): direzione.x += 1
	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT): direzione.x -= 1
	if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN): direzione.y += 1
	if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP): direzione.y -= 1
	
	# Movimento camera indipendente dallo zoom attuale
	global_position += direzione.normalized() * velocita_movimento * delta * (1.0 / zoom.x)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			_cambia_zoom(zoom_velocita)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_cambia_zoom(-zoom_velocita)

func _cambia_zoom(delta_z):
	var nuovo = clamp(zoom.x + delta_z, zoom_min, zoom_max)
	zoom = Vector2(nuovo, nuovo)
