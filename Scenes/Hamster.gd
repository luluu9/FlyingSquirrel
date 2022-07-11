extends RigidBody2D


export var jumpVel = Vector2(1000, -2000)
var slowdownStartLimit = 250;
var slowdownFactor = 0.1;
var landedLimit = 3;
var allowJump = false;
var onGround = false;


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (allowJump and Input.is_action_just_pressed("space")):
		apply_central_impulse(jumpVel);
	if (onGround):
		if (linear_velocity.length() < slowdownStartLimit):
			slowdown()
	#print(linear_velocity.length());
	print(position.y)

func _on_JumpArea_body_entered(body):
	allowJump = true;
	$JumpLabel.show();


func _on_JumpArea_body_exited(body):
	allowJump = true;
	$JumpLabel.hide();


func slowdown():
	apply_central_impulse(-linear_velocity * slowdownFactor)
	if (linear_velocity.length() < landedLimit):
		land()


func land():
	print("STOP")

func _on_Hamster_body_entered(body):
	if (body.name == "Ground"):
		onGround = true;


func _on_Hamster_body_exited(body):
	if (body.name == "Ground"):
		onGround = false;
