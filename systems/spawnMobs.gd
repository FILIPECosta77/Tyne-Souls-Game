class_name MobSpawner
extends Node2D

@export var enemies: Array[PackedScene]
var mobsPerMinute: float = 60

@onready var spawMob: PathFollow2D = %PathFollow2D
var colldown: float = 0.0

func _process(delta):
	if GameSets.isGameOver: return
	
#	define e verifica colldown
	colldown -= delta
	if colldown > 0: return
	
#	define intervalo de tempo entre o spawn de um mob
	var interval = 60 / mobsPerMinute
	colldown = interval
	
#	verificar se é possivel spawnar o enemy
	var position = getPosition()
	var worldState = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = position 
	var result: Array = worldState.intersect_point(parameters, 1)
	if not result.is_empty(): return
	
#	seleciona inimigo aleatorio
	var index = randi_range(0, (enemies.size()-1))
	var mobScense = enemies[index]
#	instancia a criatura
	var mob = mobScense.instantiate()
#	posiciona a criatura
	mob.global_position = position
	get_parent().add_child(mob)

func getPosition()-> Vector2:
	spawMob.progress_ratio = randf()
	return spawMob.global_position
