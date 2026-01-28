extends CharacterBody2D


const SPEED = 600.0
const JUMP_VELOCITY = -1500.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		GameManager.playSoundFX(load("res://assets/Sounds/Retro Jump 01.wav"))
		velocity.y = JUMP_VELOCITY
		$AnimatedSprite2D.play("jump")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var run_multiplier = 1
	if Input.is_action_pressed("run"):
		run_multiplier = 2
	else:
		run_multiplier = 1
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED * run_multiplier
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	# Lógica de animaciones (prioridad: salto > caminar > idle)
	if not is_on_floor():
		# Si está en el aire, usa salto (o "fall" si tienes esa animación)
		if velocity.y < 0:
			$AnimatedSprite2D.play("jump")
		else:
			$AnimatedSprite2D.play("fall")  # ← Opcional, si tienes anim fall
	else:
		# Solo en suelo: caminar o idle
		if velocity.x != 0:
			$AnimatedSprite2D.play("walk")
		else:
			$AnimatedSprite2D.play("idle")
	
	# Flip del sprite (después de animaciones para evitar conflictos)
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = false

	move_and_slide()
	
	if Input.is_action_just_pressed("magic"):
		GameManager.playSoundFX(load("res://assets/Sounds/Retro Magic Protection 25.wav"))
		var magicNode = load("res://scenes/magic_area.tscn")
		var newMagic = magicNode.instantiate()
		if $AnimatedSprite2D.flip_h == false:
			newMagic.direction = -1
		else:
			newMagic.direction = 1
		get_parent().add_child(newMagic)
		newMagic.global_position = %MagicSpawnpoint.global_position

func killPlayer():
	GameManager.playSoundFX(load("res://assets/Sounds/Retro Descending Long 04.wav"))
	position = %RespawnPoint.position
	$AnimatedSprite2D.flip_h = false
	
func _on_death_area_body_entered(body: Node2D) -> void:
	killPlayer()
	
