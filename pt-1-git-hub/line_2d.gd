extends Line2D

@onready var nav_agent = get_node("../Nave/NavigationAgent2D")
@onready var nave = get_node("../Nave")

func _ready():
	width = 2.5
	default_color = Color("ffeb3b")
	joint_mode = Line2D.LINE_JOINT_ROUND
	begin_cap_mode = Line2D.LINE_CAP_ROUND
	end_cap_mode = Line2D.LINE_CAP_ROUND
	antialiased = true
	
	# Forza la rotta più breve possibile
	nav_agent.path_postprocessing = NavigationPathQueryParameters2D.PATH_POSTPROCESSING_CORRIDORFUNNEL

func _process(_delta):
	if nav_agent.is_navigation_finished():
		points = PackedVector2Array() # Pulisce la linea quando arrivi
		return

	var punti_rotta = nav_agent.get_current_navigation_path()
	if punti_rotta.size() > 1:
		punti_rotta[0] = nave.global_position
		points = punti_rotta
	else:
		points = PackedVector2Array()
