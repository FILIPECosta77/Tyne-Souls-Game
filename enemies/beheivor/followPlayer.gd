extends Node

@export var speed: float = 1 

var enemy: Enemy
var sprite: AnimatedSprite2D 

func _ready():
	enemy = get_parent()
	sprite = enemy.get_node("AnimatedSprite2D")
	pass

func _physics_process(delta: float) -> void:
	if GameSets.isGameOver: return
	
	var playerPosition: Vector2 = GameSets.playerPosition
#	Subtrai as diferenças de valores entre 'player' e 'enemy'
	var differencePosition = playerPosition - enemy.position
	var inputVector = differencePosition.normalized()
	enemy.velocity = inputVector * speed * 50
	enemy.move_and_slide()
	
	if inputVector.x < 0:
		sprite.flip_h = true
	elif inputVector.x > 0:
		sprite.flip_h = false 
