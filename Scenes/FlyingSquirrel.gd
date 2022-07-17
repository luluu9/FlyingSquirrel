extends KinematicBody2D

var speed = 400 # px per sec
var steeringSpeed = 30 # in degrees per second
var fallingDownSpeed = 15# in degrees direcing nose downwards
var gravity = 500 # speed gain per sec if directed downwards
var airResistance = 20
var speedToBlockGoingUp = 100
var minSpeed = 50 # to prevent stopping in the air

var rolling = false

func _ready():
	pass


func _process(delta):
	if (Input.is_action_pressed("up")):
		rotation -= deg2rad(steeringSpeed)*delta
	if (Input.is_action_pressed("down")):
		rotation += deg2rad(steeringSpeed)*delta


func _physics_process(delta):
	if rolling:
		rotation += speed/30*delta
		speed -= 100*delta
		speed = max(0, speed)
		var angleVec = Vector2(1, 0) 
		var velocity = speed*angleVec
		move_and_slide(velocity)
	else:
		calculatePhysics(delta)
		var angleVec = Vector2(cos(rotation), sin(rotation)) 
		var velocity = speed*angleVec
		var collision = move_and_collide(velocity*delta)
		if collision:
			velocity = velocity.slide(collision.normal)
			angleVec = velocity.normalized()
			rotation = angleVec.angle()
			position = collision.position
			changeFormToBall()


func calculatePhysics(delta):
	if (speed < speedToBlockGoingUp):
		rotation += minSpeed*delta/speed
	rotation += deg2rad(fallingDownSpeed)*delta
	rotation = clamp(rotation, -PI/2, PI/2)
	speed += gravity*delta*rotation
	speed -= airResistance*delta
	speed = max(minSpeed, speed)

func changeFormToBall():
	$AnimationPlayer.play("roll")
	rolling = true
