class_name Enemy
extends Node2D

@onready var damageDigitMarker: Marker2D = $damageDigit

@export var life: int = 5
@export var inflictedDamage: int = 1
@export var deathAnim: PackedScene
@export var dropGold: PackedScene
@export var damageDigit: PackedScene

#func _ready():
	#damageDigit = preload("res://enemies/beheivor/damageDigit.tscn")


func damage(amount: int)-> void:
	life -= amount
	
	modulate = Color.INDIAN_RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.15)
	
#	damageDigit
	var damager = damageDigit.instantiate()
	damager.value = amount
	damager.global_position = damageDigitMarker.global_position
	print("Enemy:", position, "DigitMarker:", damager.global_position)
	get_parent().add_child(damager)
	
	if life <= 0:
		die()
			

func die()-> void:
	GameSets.enemysDefeated += 1
	
	if deathAnim:
		var deathObject = deathAnim.instantiate()
		deathObject.position = position
		get_parent().add_child(deathObject)
		
		var goldDroped = dropGold.instantiate()
		goldDroped.position = Vector2(position.x + 25.0, position.y - 25.0)
		get_parent().add_child(goldDroped)
		
	queue_free()
