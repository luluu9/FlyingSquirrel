extends Area2D


func _on_Hazelnut_body_entered(body):
	var player = body as RigidBody2D
	if player:
		#player.apply_central_impulse(Vector2(300, -300))
		player.addFart()
