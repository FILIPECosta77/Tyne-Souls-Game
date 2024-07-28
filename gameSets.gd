extends Node

signal gameOver()

var player: Player
var playerPosition: Vector2
var isGameOver: bool = false

var timer: float = 0.0
var timerText: String
var gold: int = 0
var enemysDefeated: int = 0

func _process(delta: float):
	if GameSets.isGameOver: return
	
	timer += delta
	var timerInSeconds: int = floori(timer)
	var seconds: int = timerInSeconds % 60
	var minutes: int = timerInSeconds / 60
	timerText = "%02d:%02d" % [minutes, seconds]

func endGame():
	if isGameOver: return
	isGameOver = true
	gameOver.emit()


func reset():
	player = null
	playerPosition = Vector2.ZERO
	isGameOver = false
	for connection in gameOver.get_connections():
		gameOver.disconnect(connection.callable)
	 
	timer = 0.0
	timerText = "00:00"
	gold = 0
	enemysDefeated = 0
