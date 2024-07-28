extends Node2D

@export var goldAmount: int = randf_range(0, 5)

@onready var areaToCollectItem: Area2D = $colectedArea

func _ready():
	areaToCollectItem.body_entered.connect(onEntered)
	
func onEntered(body: Node2D)-> void:
	if body.is_in_group("player"):
		var player: Player = body
		player.goldCollected.emit(goldAmount)
		queue_free()
