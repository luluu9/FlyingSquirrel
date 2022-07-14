extends Node

var farthestDistance = 0 setget updateFarthest
onready var groundY = $Ground.global_position.y
var adjustGroundMargin = 500
export var startPos = Vector2(-250, -800)
onready var bonuses = {
	hazelnuts = {
		amount = 4,
		scene = preload("res://Scenes/Hazelnut.tscn"),
		offset = Vector2(0, -300),
		start = Vector2(1000, 0)
	},
	
	loadRects = 2, # load x rects with bonuses forward
	furthestLoaded = 0, # i-th loaded rect with bonuses 
	rect = get_viewport().size + Vector2(0, 1000)
}

func _process(delta):
	if ($Hamster.position.y < groundY+adjustGroundMargin):
		$Ground.position.x = $Hamster.position.x
	loadBonuses()


func updateFarthest(newValue):
	if (newValue > farthestDistance):
		farthestDistance = newValue
		$DistanceFlag.position.x = farthestDistance
		$DistanceFlag.visible = true


func loadBonuses():
	var hamsterIthRectX = max(0, $Hamster.position.x / bonuses.rect.x)
	var hamsterIthRectY = max(0, $Hamster.position.y / bonuses.rect.y)
	while (bonuses.furthestLoaded-hamsterIthRectX < bonuses.loadRects):
		for bonus in bonuses.values(): 
			if (bonus is Dictionary):
				var loadRect = Vector2(bonuses.furthestLoaded*bonuses.rect.x, bonuses.rect.y)
				createBonus(bonus, loadRect) 
		bonuses.furthestLoaded += 1


# change startX to just start (vector2)
func createBonus(bonusSettings, start):
	if (start.x < bonusSettings.start.x): return
	if (start.y < bonusSettings.start.y): return
	for i in range(0, bonusSettings.amount):
		# as Y-axis is inverted, I have to substract from grondY to make rect up
		var randomPos = Vector2(start.x + rand_range(0, bonuses.rect.x),
								groundY - start.y + rand_range(0, bonuses.rect.y))
		randomPos += bonusSettings.offset
		var bonusInstance = bonusSettings.scene.instance()
		bonusInstance.position = randomPos
		add_child(bonusInstance)
		print("Added on pos ", randomPos)


func _on_Hamster_landed(position_x):
	updateFarthest(position_x)
	yield(get_tree().create_timer(1.0), "timeout")
	resetHamster()


func resetHamster():
	$Hamster.position = startPos
	$Hamster.reset()

