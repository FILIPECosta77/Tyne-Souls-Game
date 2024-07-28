extends Node2D

@export var regeneratedAmount: int = 10

@onready var areaToCollectItem: Area2D = $colectedArea

func _ready():
	areaToCollectItem.body_entered.connect(onEntered)
	
func onEntered(body: Node2D)-> void:
	if body.is_in_group("player"):
		var player: Player = body
		player.heal(regeneratedAmount)
		queue_free()
