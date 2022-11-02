extends DirectionalLight

func _on_Timer_timeout():
	#on timer timeout look at the players location
	look_at(Globals.player.global_transform.origin, Vector3.UP)
