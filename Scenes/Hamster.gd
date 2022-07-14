extends RigidBody2D

signal landed(position_y)

export var jumpVel = Vector2(1000, -2000)
export var fartVel = Vector2(500, -300)
var slowdownStartLimit = 250
var slowdownFactor = 0.1
var landedLimit = 3
var allowJump = false
var allowFart = true
var onGround = false
var landed = false


func reset():
	landed = false
	onGround = false
	allowJump = false
	allowFart = true


func _process(delta):
	if (allowJump and Input.is_action_just_pressed("space")):
		jump()
	elif (allowFart and Input.is_action_just_pressed("space")):
		fart()
		
	if (onGround):
		if (linear_velocity.length() < slowdownStartLimit):
			slowdown()


func jump():
	print("Jumping!")
	allowJump = false
	apply_central_impulse(jumpVel)


func fart():
	print("Farting!")
	$FartParticles.emitting = true
	apply_central_impulse(fartVel )
	allowFart = false

func addFart():
	print("Adding fart to stomach!")
	allowFart = true


func slowdown():
	apply_central_impulse(-linear_velocity * slowdownFactor)
	if (linear_velocity.length() < landedLimit):
		land()


func land():
	if (not landed):
		landed = true
		allowFart = false
		allowJump = false
		emit_signal("landed", position.x)


func _on_JumpArea_body_entered(body):
	allowJump = true
	$JumpLabel.show()


func _on_JumpArea_body_exited(body):
	allowJump = false
	$JumpLabel.hide()


func _on_Hamster_body_entered(body):
	if (body.name == "Ground"):
		onGround = true


func _on_Hamster_body_exited(body):
	if (body.name == "Ground"):
		onGround = false
