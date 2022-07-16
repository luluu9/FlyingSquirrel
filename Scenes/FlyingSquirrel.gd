extends KinematicBody2D

var speed = 400 # px per sec
var steeringSpeed = 30 # in degrees per second
var fallingDownSpeed = 4 # in degrees direcing nose downwards
var gravity = 500 # speed gain per sec if directed downwards
var airResistance = 30
var speedToBlockGoingUp = 100
var minSpeed = 50 # to prevent stopping in the air


func _ready():
	pass


func _process(delta):
	if (Input.is_action_pressed("up")):
		rotation -= deg2rad(steeringSpeed)*delta
	if (Input.is_action_pressed("down")):
		rotation += deg2rad(steeringSpeed)*delta


func _physics_process(delta):
	if (speed < speedToBlockGoingUp):
		rotation += minSpeed*delta/speed
	rotation += deg2rad(fallingDownSpeed)*delta
	rotation = clamp(rotation, -PI/2, PI/2)
	speed += gravity*delta*rotation
	speed -= airResistance*delta
	speed = max(minSpeed, speed)
	var angleVec = Vector2(cos(rotation), sin(rotation)) 
	# print(speed*angleVec, "\t", position.x, "\t", speed)
	move_and_collide(speed*angleVec*delta)
