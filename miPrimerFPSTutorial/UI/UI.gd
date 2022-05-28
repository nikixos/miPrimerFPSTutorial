extends Control

onready var barraVida : TextureProgress = $BarraDeVida
onready var municionTexto : Label = $MunicionTexto
onready var scoreTexto : Label = $ScoreTexto

func actualizaBarraVida (vidaAhora, maximaVida):
	barraVida.max_value = maximaVida
	barraVida.value = vidaAhora

func actualizaAmmo (ammo):
	municionTexto.text = "Ammo: "+str(ammo)

func actualizaScore(score):
	scoreTexto.text = "Score: "+str(score)
	
