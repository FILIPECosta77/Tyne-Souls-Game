extends Node

@export var magicDamage = 4

@onready var area: Area2D = $Area2D

func _ready():
	pass

func inflicDamage()-> void:
	var bodies = area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			enemy.damage(magicDamage)
