extends Node

var farthestDistance = 0 setget updateFarthest
onready var groundY = $Ground.global_position.y
var adjustGroundMargin = 500
export var startPos = Vector2(-250, -800)


func _ready():
	pass # Replace with function body.


func _process(delta):
	if ($Hamster.position.y < groundY+adjustGroundMargin):
		$Ground.position.x = $Hamster.position.x


func updateFarthest(newValue):
	if (newValue > farthestDistance):
		farthestDistance = newValue
		$DistanceFlag.position.x = farthestDistance
		$DistanceFlag.visible = true


func _on_Hamster_landed(position_x):
	updateFarthest(position_x)
	yield(get_tree().create_timer(1.0), "timeout")
	resetHamster()


func resetHamster():
	$Hamster.position = startPos
	$Hamster.reset()
