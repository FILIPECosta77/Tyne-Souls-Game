extends Node

@export var mobSpawner: MobSpawner
@export var initialSpawnRate: float = 60.0
@export var spawnRatePerMinute: float = 30.0
@export var waveDuration: float = 30.0
@export var waveIntensity: float = 0.5

var timer: float = 0.0

func _process(delta: float)-> void:
	if GameSets.isGameOver: return
	
	timer += delta
	
#	calculo da dificuldade linear
	var spawRate = initialSpawnRate + spawnRatePerMinute * (timer / 60)
	
#	calculo do sistema de ondas
	var wave = sin((timer * TAU) / waveDuration)
	var waveBreaker = remap(wave, -1.0, 1.0, waveIntensity, 1.0)
	
	spawRate *= waveBreaker
	
#	aplica dificuldade
	mobSpawner.mobsPerMinute = spawRate
