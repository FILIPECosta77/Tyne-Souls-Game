extends CanvasLayer

@onready var timerLabel: Label = %TimerLabel
@onready var goldLabel: Label = %GoldLabel
@onready var enemysLabel: Label = %EnemysLabel

@export var restartDelay: float = 5.0
var restartColldown: float

func _ready():
	restartColldown = restartDelay
	timerLabel.text = GameSets.timerText
	goldLabel.text = str(GameSets.gold)
	enemysLabel.text = str(GameSets.enemysDefeated)

func _process(delta):
	restartColldown -= delta
	if restartColldown <= 0:
		restartGame()

func restartGame():
	GameSets.reset()
	get_tree().reload_current_scene()
