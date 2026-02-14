extends Area2D

@onready var menu_pergamena = $CanvasLayer/TextureRect
@onready var finestra_mercato = $CanvasLayer/FinestraMercato
@onready var container_lista = $CanvasLayer/FinestraMercato/ScrollContainer/ListaContenuto
@onready var label_oro = $CanvasLayer/LabelOro

# Percorso corretto aggiornato
var font_cinzel = preload("res://cinzel/Cinzel Family/Cinzel/Cinzel-Bold.ttf")

var sezione_attuale = "Mercato"
var quantita_scambio = 1 

var inventario = {
	"Grano": {"prezzo": 90, "citta": 100, "nave": 0, "magazzino": 0, "tipo": "merce"},
	"Pesce": {"prezzo": 235, "citta": 50, "nave": 0, "magazzino": 0, "tipo": "merce"},
	"Carne": {"prezzo": 260, "citta": 40, "nave": 0, "magazzino": 0, "tipo": "merce"},
	"Patate": {"prezzo": 205, "citta": 80, "nave": 0, "magazzino": 0, "tipo": "merce"},
	"Rum": {"prezzo": 395, "citta": 30, "nave": 0, "magazzino": 0, "tipo": "merce"},
	"Stoffe": {"prezzo": 300, "citta": 40, "nave": 0, "magazzino": 0, "tipo": "merce"},
	"Sale": {"prezzo": 240, "citta": 60, "nave": 0, "magazzino": 0, "tipo": "merce"},
	"Mattoni": {"prezzo": 140, "citta": 150, "nave": 0, "magazzino": 0, "tipo": "merce"},
	"Legname": {"prezzo": 40, "citta": 200, "nave": 0, "magazzino": 0, "tipo": "merce"},
	"Canapa": {"prezzo": 400, "citta": 20, "nave": 0, "magazzino": 0, "tipo": "merce"},
	"Tabacco": {"prezzo": 800, "citta": 15, "nave": 0, "magazzino": 0, "tipo": "merce"},
	"Tinture": {"prezzo": 200, "citta": 35, "nave": 0, "magazzino": 0, "tipo": "merce"},
	"Cacao": {"prezzo": 400, "citta": 25, "nave": 0, "magazzino": 0, "tipo": "merce"},
	"Zucchero": {"prezzo": 130, "citta": 100, "nave": 0, "magazzino": 0, "tipo": "merce"},
	"Cotone": {"prezzo": 100, "citta": 110, "nave": 0, "magazzino": 0, "tipo": "merce"},
	"Vino": {"prezzo": 500, "citta": 10, "nave": 0, "magazzino": 0, "tipo": "merce"},
	"Attrezzi": {"prezzo": 300, "citta": 20, "nave": 0, "magazzino": 0, "tipo": "merce"},
	"Ceramica": {"prezzo": 200, "citta": 30, "nave": 0, "magazzino": 0, "tipo": "merce"},
	"Indumenti": {"prezzo": 400, "citta": 15, "nave": 0, "magazzino": 0, "tipo": "merce"},
	"Marinai": {"prezzo": 0, "citta": 250, "nave": 20, "magazzino": 0, "tipo": "dotazione"},
	"Sciabole": {"prezzo": 55, "citta": 100, "nave": 10, "magazzino": 0, "tipo": "dotazione"},
	"Cannoni": {"prezzo": 450, "citta": 12, "nave": 4, "magazzino": 0, "tipo": "dotazione"},
	"Palle Cannone": {"prezzo": 10, "citta": 400, "nave": 50, "magazzino": 0, "tipo": "dotazione"},
	"Palle Incatenate": {"prezzo": 15, "citta": 150, "nave": 20, "magazzino": 0, "tipo": "dotazione"},
	"Palle Mitraglia": {"prezzo": 12, "citta": 200, "nave": 30, "magazzino": 0, "tipo": "dotazione"},
	"Fucili": {"prezzo": 85, "citta": 50, "nave": 5, "magazzino": 0, "tipo": "dotazione"},
	"Coloni": {"prezzo": 0, "citta": 500, "nave": 0, "magazzino": 0, "tipo": "dotazione"}
}

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS 
	_nascondi_tutti_i_menu()
	
	# Connessioni pulsanti sezioni
	$CanvasLayer/FinestraMercato/Btn_Sez_Mercato.pressed.connect(func(): cambia_sezione("Mercato"))
	$CanvasLayer/FinestraMercato/Btn_Sez_Dotazione.pressed.connect(func(): cambia_sezione("Dotazione"))
	$CanvasLayer/FinestraMercato/Btn_Sez_Magazzino.pressed.connect(func(): cambia_sezione("Magazzino"))
	$CanvasLayer/FinestraMercato/Button_ChiudiMercato.pressed.connect(_on_chiudi_mercato_pressed)
	$CanvasLayer/TextureRect/MenuAttracco/Button_Mercato.pressed.connect(_on_mercato_pressed)
	
	# FIX TASTO 100: Controlliamo entrambi i nomi possibili
	if $CanvasLayer/FinestraMercato.has_node("Btn_Q1"):
		$CanvasLayer/FinestraMercato/Btn_Q1.pressed.connect(func(): quantita_scambio = 1)
	if $CanvasLayer/FinestraMercato.has_node("Btn_Q10"):
		$CanvasLayer/FinestraMercato/Btn_Q10.pressed.connect(func(): quantita_scambio = 10)
	if $CanvasLayer/FinestraMercato.has_node("Btn_Q100"):
		$CanvasLayer/FinestraMercato/Btn_Q100.pressed.connect(func(): quantita_scambio = 100)
	elif $CanvasLayer/FinestraMercato.has_node("Btn_Q101"):
		$CanvasLayer/FinestraMercato/Btn_Q101.pressed.connect(func(): quantita_scambio = 100)

	if $CanvasLayer/TextureRect/MenuAttracco.has_node("Button_Esci"):
		$CanvasLayer/TextureRect/MenuAttracco/Button_Esci.pressed.connect(_on_esci_pressed)
	
	body_entered.connect(_on_nave_entrata)
	aggiorna_interfaccia()

func cambia_sezione(nuova):
	sezione_attuale = nuova
	aggiorna_interfaccia()

func aggiorna_interfaccia():
	# Aggiorna sempre la Label dell'Oro quando l'interfaccia cambia
	if label_oro:
		label_oro.text = "Oro: " + str(Global.oro)
		label_oro.add_theme_font_override("font", font_cinzel)
		label_oro.add_theme_font_size_override("font_size", 40)
	
	for n in container_lista.get_children(): n.queue_free()
	
	var col_parole = Color("8b6b3d")
	var col_tasti = Color("5d4629")

	for nome in inventario.keys():
		var info = inventario[nome]
		if sezione_attuale == "Mercato" and info.tipo != "merce": continue
		if sezione_attuale == "Dotazione" and info.tipo != "dotazione": continue
		
		var riga = VBoxContainer.new()
		var riga_testo = HBoxContainer.new()
		var riga_pulsanti = HBoxContainer.new()
		
		var lbl = Label.new()
		var p_val = " (" + str(info.prezzo) + "o)" if info.prezzo > 0 else ""
		lbl.text = "%s%s [C:%d N:%d M:%d]" % [nome, p_val, info.citta, info.nave, info.magazzino]
		
		lbl.add_theme_font_override("font", font_cinzel)
		lbl.add_theme_font_size_override("font_size", 34) 
		lbl.add_theme_color_override("font_color", col_parole)
		
		riga_testo.add_child(lbl)
		
		# Mantiene la disposizione richiesta
		if sezione_attuale == "Mercato" or sezione_attuale == "Dotazione":
			_crea_btn(riga_pulsanti, "COMPRA", nome, "citta", "nave", col_tasti)
			_crea_btn(riga_pulsanti, "VENDI", nome, "nave", "citta", col_tasti)
		else: 
			_crea_btn(riga_pulsanti, "CITTÀ->MAG", nome, "citta", "magazzino", col_tasti)
			_crea_btn(riga_pulsanti, "MAG->NAVE", nome, "magazzino", "nave", col_tasti)
			_crea_btn(riga_pulsanti, "CITTÀ->NAVE", nome, "citta", "nave", col_tasti)
			_crea_btn(riga_pulsanti, "VENDI", nome, "nave", "citta", col_tasti)

		riga.add_child(riga_testo)
		riga.add_child(riga_pulsanti)
		riga.add_theme_constant_override("separation", 8) 
		container_lista.add_child(riga)

func _crea_btn(parent, testo, nome, da, a, colore):
	var b = Button.new()
	b.text = testo
	b.flat = true
	b.add_theme_font_override("font", font_cinzel)
	b.add_theme_font_size_override("font_size", 26) 
	b.add_theme_color_override("font_color", colore)
	b.pressed.connect(func(): trasferisci(nome, da, a))
	parent.add_child(b)

func trasferisci(nome, da, a):
	var info = inventario[nome]
	
	# LOGICA ACQUISTO FLESSIBILE: compra il massimo possibile fino a 'quantita_scambio'
	var quantita_reale = min(quantita_scambio, info[da])
	
	if quantita_reale > 0:
		var costo = info.prezzo * quantita_reale
		
		# Se stiamo comprando dalla città, verifichiamo se abbiamo abbastanza oro
		if a == "nave" and da == "citta": 
			if Global.oro >= costo:
				Global.oro -= costo
			else:
				# Se non abbiamo oro per tutto, compriamo solo quello che possiamo permetterci
				var max_permesso = floor(Global.oro / info.prezzo)
				quantita_reale = min(quantita_reale, max_permesso)
				costo = info.prezzo * quantita_reale
				if quantita_reale <= 0: return # Impossibile comprare anche solo 1 unità
				Global.oro -= costo
		
		elif da == "nave" and a == "citta": 
			Global.oro += costo
		
		# Esecuzione scambio
		info[da] -= quantita_reale
		info[a] += quantita_reale
		aggiorna_interfaccia()

func _on_chiudi_mercato_pressed():
	finestra_mercato.visible = false
	menu_pergamena.visible = true 

func _on_mercato_pressed():
	menu_pergamena.visible = false
	finestra_mercato.visible = true

func _nascondi_tutti_i_menu():
	menu_pergamena.visible = false
	finestra_mercato.visible = false

func _on_nave_entrata(body):
	if body.name == "Nave":
		menu_pergamena.visible = true
		get_tree().paused = true 
		aggiorna_interfaccia()

func _on_esci_pressed():
	menu_pergamena.visible = false
	get_tree().paused = false
