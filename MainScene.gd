extends Node2D

@export var gameUI: GameUI
@export var gameOverUI: PackedScene

func _ready():
	GameSets.gameOver.connect(setOnGameOver)

func setOnGameOver():
	if gameUI:
		gameUI.queue_free()
		gameUI = null
		
	var gameOverUITemplate = gameOverUI.instantiate()
	add_child(gameOverUITemplate)
