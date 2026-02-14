# Script per mostrare l'oro a schermo
extends Node2D

@onready var label_oro = $CanvasLayer/LabelOro

func _process(_delta):
	# Aggiorna il testo ogni secondo con il valore di Global
	label_oro.text = "Oro: " + str(Global.oro)
