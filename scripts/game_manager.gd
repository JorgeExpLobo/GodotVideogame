extends Node

var coins = 0
var score = 0

func playSoundFX(stream):
	$SoundFX.stream = stream
	$SoundFX.play()

func _process(delta: float) -> void:
	$"GUI/CoinsValue".text = str(coins)
	$"GUI/ScoreValue".text = str(score)
