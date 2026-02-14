extends CharacterBody2D

@export var velocita := 1000.0
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var sprite: Sprite2D = $Sprite2D # Assicurati che il nodo si chiami Sprite2D

func _ready():
	nav_agent.path_desired_distance = 10.0
	nav_agent.target_desired_distance = 15.0
	
	# Blocca la rotazione del nodo così rimane sempre dritto
	rotation = 0 
	
	var mappa = get_node_or_null("../MappaMondo/Sprite2D")
	if mappa:
		mappa.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _physics_process(_delta):
	# Click TASTO DESTRO per muoversi
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		nav_agent.target_position = get_global_mouse_position()

	if nav_agent.is_navigation_finished():
		velocity = Vector2.ZERO
		return

	var next_path_pos = nav_agent.get_next_path_position()
	var direzione = global_position.direction_to(next_path_pos)
	
	velocity = direzione * velocita
	move_and_slide() #

	# GESTIONE DELLO SGUARDO (Destra/Sinistra)
	if velocity.x > 0:
		# Se la nave va a destra, non specchiare (o specchia a seconda dell'immagine originale)
		sprite.flip_h = false 
	elif velocity.x < 0:
		# Se la nave va a sinistra, specchia l'immagine
		sprite.flip_h = true
