extends RigidBody2D

signal landed(position_y)

export var jumpVel = Vector2(1000, -2000)
var slowdownStartLimit = 250
var slowdownFactor = 0.1
var landedLimit = 3
var allowJump = false
var onGround = false
var landed = false


func _ready():
	pass # Replace with function body.


func _process(delta):
	if (allowJump and Input.is_action_just_pressed("space")):
		apply_central_impulse(jumpVel)
	if (onGround):
		if (linear_velocity.length() < slowdownStartLimit):
			slowdown()


func _on_JumpArea_body_entered(body):
	allowJump = true
	$JumpLabel.show()


func _on_JumpArea_body_exited(body):
	allowJump = false
	$JumpLabel.hide()


func reset():
	landed = false
	onGround = false
	allowJump = false


func slowdown():
	apply_central_impulse(-linear_velocity * slowdownFactor)
	if (linear_velocity.length() < landedLimit):
		land()


func land():
	if (not landed):
		emit_signal("landed", position.x)
		landed = true


func _on_Hamster_body_entered(body):
	if (body.name == "Ground"):
		onGround = true


func _on_Hamster_body_exited(body):
	if (body.name == "Ground"):
		onGround = false
