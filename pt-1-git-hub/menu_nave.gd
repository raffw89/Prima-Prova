extends Control

# --- RIFERIMENTI NODI GERARCHIA ---
@onready var lbl_capitano = $SezioneSopra/Label_Capitano
@onready var lbl_luogo = $SezioneSopra/Label_Luogo
@onready var bar_hp = $SezioneSopra/TextureProgressBar
@onready var sezione_sotto = $SezioneSotto

# --- PULSANTI BARRA ICONE ---
@onready var btn_merci = $BarraIcone/Btn_Merci
@onready var btn_flotta = $BarraIcone/Btn_Flotta
@onready var btn_rotte = $BarraIcone/Btn_Rotte
@onready var btn_nave = $BarraIcone/Btn_Nave
@onready var btn_armi = $BarraIcone/Btn_Armi

# Font per le scritte dinamiche
var font_cinzel = preload("res://cinzel/Cinzel Family/Cinzel/Cinzel-Bold.ttf")

func _ready():
	# Inizializzazione dati all'avvio
	aggiorna_menu()
	
	# Connessione segnali pulsanti barra centrale
	btn_merci.pressed.connect(_on_btn_merci_pressed)
	btn_flotta.pressed.connect(_on_btn_flotta_pressed)
	btn_rotte.pressed.connect(_on_btn_rotte_pressed)
	btn_nave.pressed.connect(_on_btn_nave_pressed)
	btn_armi.pressed.connect(_on_btn_armi_pressed)

func aggiorna_menu():
	# Legge i dati dal Global (GPS e Statistiche)
	lbl_capitano.text = "Capitano: " + Global.capitano
	lbl_luogo.text = "Luogo: " + Global.posizione_attuale
	bar_hp.value = (Global.hp_attuali / Global.hp_max) * 100

# --- LOGICA PULSANTI BARRA ICONE ---

func _on_btn_merci_pressed():
	_pulisci_sezione_sotto()
	var label = Label.new()
	label.text = "STIVA NAVE: Carico attuale..."
	label.add_theme_font_override("font", font_cinzel)
	sezione_sotto.add_child(label)
	# Qui in futuro cicleremo l'inventario del Global per mostrare le icone

func _on_btn_flotta_pressed():
	_pulisci_sezione_sotto()
	var label = Label.new()
	label.text = "FLOTTA: Lista delle tue navi"
	label.add_theme_font_override("font", font_cinzel)
	sezione_sotto.add_child(label)

func _on_btn_rotte_pressed():
	_pulisci_sezione_sotto()
	print("Sezione Rotte Commerciali")

func _on_btn_nave_pressed():
	_pulisci_sezione_sotto()
	print("Dettagli Tecnici Nave")

func _on_btn_armi_pressed():
	_pulisci_sezione_sotto()
	print("Equipaggiamento Armi")

# Utility per svuotare la pergamena prima di cambiare scheda
func _pulisci_sezione_sotto():
	for child in sezione_sotto.get_children():
		child.queue_free()

# --- GESTIONE CHIUSURA ---
func _on_tasto_chiudi_pressed():
	self.visible = false
	get_tree().paused = false
