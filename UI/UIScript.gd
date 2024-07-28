class_name GameUI
extends CanvasLayer

@onready var timer_label: Label = %Timer
@onready var gold_label: Label = %Gold

func _process(delta: float):
	timer_label.text = GameSets.timerText
	gold_label.text = str(GameSets.gold)
