class_name Player
extends CharacterBody2D

@onready var playerAnimation: AnimationPlayer = $AnimationPlayer
@onready var sprite2D: Sprite2D = $Sprite2D
@onready var swordArea: Area2D = $DamageArea
@onready var hitBoxArea: Area2D = $HitBoxArea
@onready var healthBar: ProgressBar = $ProgressBar

@export_category("Health")
@export var life: int = 100
@export var maxLife: int = 100
@export var deathAnim: PackedScene
@export_category("Damage")
@export var swordDamage: int = 2
@export_category("Speed")
@export var speed: int = 3
@export_category("Ritual")
@export var intervalRitual:float = 15
@export var ritualAnim: PackedScene

var inputKeys: Vector2 = Vector2(0,0)
var isRunning: bool = true
var wasRunning: bool
var isAttacking: bool = false
var attackColldown: float = 0.0
var hitBoxColldown: float = 0.0
var ritualColldown: float = 0.0

signal goldCollected(value: int)

func _ready():
	GameSets.player = self
	goldCollected.connect(func(value: int): GameSets.gold += 1)

func _process(delta: float) -> void:
#	Atualiza a posiçao do player na cena Global
	GameSets.playerPosition = position
	
#	Armazena os valores de movimentação onde o primeiro valor é de -1 para moveLeft e 1 para moveRight
#   O segundo é de -1 para moveUp e 1 para moveDown, Caso a tecla não esteja prescionada o valor sempre séra 0
	inputKeys = Input.get_vector("moveLeft", "moveRight", "moveUp", "moveDown")

	animations(delta)
	#	Inicia animação de ataque
	if Input.is_action_just_pressed("attack"):
		playerAttack()
	
#	Processa Dano Recebido
	receiveDamage(delta)
	
#	Inicia ritual
	ritualAttack(delta)
	
#	Atualiza a Barra de Vida
	healthBar.max_value = maxLife
	healthBar.value = life


@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
#	Caucula a velocidade do jogador
	var targetSpeed = inputKeys * speed * 100
	if isAttacking: 
#		Se tiver atacando, diminoi a velocidade de movimento do jogador
		targetSpeed *= 0.25
# 	Caucula velocidade do jogador em Pixels por segundo (300 pixels por segundo)
	velocity = lerp(velocity, targetSpeed, 0.5)
	move_and_slide()
	
	wasRunning = isRunning
	# se inputKeys for diferente de zero, isRunnig tem seu valor invertido
	isRunning = not inputKeys.is_zero_approx()

func animations(delta: float) -> void:
	if isAttacking:
#		O Colldonw de ataque é de 0.6 menos o valor de frames por segundo
		attackColldown -= delta
		if attackColldown <= 0.0:
#			Se o colldown for menor que 0, o jogador deve estar parado
			isAttacking = false 
			isRunning = false
			playerAnimation.play("Idle")
	else:
		if wasRunning != isRunning:
			if isRunning:
				playerAnimation.play("run")
			else:
				playerAnimation.play("Idle")
		#	Inverte a direçào do personagem
		if inputKeys[0] < 0:
			sprite2D.flip_h = true
		elif inputKeys[0] > 0:
			sprite2D.flip_h = false

func playerAttack() -> void:
	playerAnimation.play("attackBasic")
	attackColldown = 0.6
	isAttacking = true

func ritualAttack(delta: float) -> void:
	ritualColldown -= delta
	if ritualColldown > 0: return
	
	ritualColldown = intervalRitual
	
	var ritual = ritualAnim.instantiate()
	add_child(ritual)
	

#funçao chamada no meio das animaçoes
func inflictDamage()-> void:
#	Pega todos corpos dentro da area
	var bodies = swordArea.get_overlapping_bodies()
	for body in bodies:
#		Se o corpo que estiver na area for do grupo enemies
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
#			Caucula a distancio do player e do inimigo
			var playerToEnemy = (enemy.position - position).normalized()
#			Define a direção da espada com base onde o inimigo esta olhando
			var attackDirection: Vector2
			if sprite2D.flip_h:
				attackDirection = Vector2.LEFT
			else:
				attackDirection = Vector2.RIGHT
#			faz o cauculo para caucular a distancia dos dois vetores
			var dotProduct = playerToEnemy.dot(attackDirection)
#			verifica se a distancia do player com o inimigo, caso sim Ataque-o
			if dotProduct >= 0.4:
				enemy.damage(swordDamage)
				
func receiveDamage(delta: float)-> void:
	#Recebe Dano se o cooldown é ou igual a zero
	hitBoxColldown -= delta
	if hitBoxColldown > 0 : return
	
#	reseta o cooldown para que a cada 2 vezes por segundo o nimigo tome dano
	hitBoxColldown = 0.5
	
	var bodies = hitBoxArea.get_overlapping_bodies()
	for body in bodies:
#		Se o corpo que estiver na area está no grupo enemies
		if body.is_in_group("enemies"):
#			recebe dano
			var enemy: Enemy = body
			damage(enemy.inflictedDamage)
	

func damage(amount: int)-> void:
	if life <= 0: return
	
	life -= amount
	print("O jogodaor recebeu dano, Sua vida agora é: ", life, " / ", maxLife)
	
	modulate = Color.INDIAN_RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.15)
	
	if life <= 0:
		die()
			

func die()-> void:
	GameSets.endGame()
	
	if deathAnim:
		var deathObject = deathAnim.instantiate()
		deathObject.position = position
		get_parent().add_child(deathObject)
	
	queue_free()

func heal(amount: int)-> int:
	life += amount
	if life >= maxLife:
		life = maxLife
	print("O jogodaor curou vida, Sua vida agora é: ", life, " / ", maxLife)
	
	return life

