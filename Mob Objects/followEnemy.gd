extends Sprite

var speed = 200

var velocity = Vector2()
var stun = false
var hp = 3
var playOnlyOnce = false
var dyingNow = false
var blood_particles = preload("res://Blood_particles.tscn")
var countToOne = 0

#we got the formula for shooting/direction at the player with the direction to
func _process(delta: float) -> void:
	if Global.player != null and stun == false:
		velocity = global_position.direction_to(Global.player.global_position)
	elif stun:
		velocity = lerp(velocity, Vector2(0,0), 0.3)
	
	global_position += velocity * speed * delta
	
	if hp <= 0:
		#$Pop.play()
		if Global.node_creation_parent != null and countToOne < 1:
			#.visible  = false
			#$.visible = false
			countToOne += 1
			var blood_particles_instance = Global.instance_node(blood_particles, global_position, Global.node_creation_parent)
			blood_particles_instance.rotation = velocity.angle()
			#play explosion
			Global.score += 5
			if countToOne == 1:
				_playSong()
		if dyingNow  == true:
			queue_free() #just for now

#call an animation player which keeps on looping but do it like a natural bubble loop
#have the bubble make a tiny trail


func _on_HitBox_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemy_damager") and stun == false:
		modulate = Color.red
		velocity = -velocity * 6
		hp -=1
		stun = true
		$Stun_timer.start()
		area.get_parent().queue_free() #get parent gets the whole bullet instead of just hitbox



func _playSong()->void:
	$Pop.play()
	$Die_timer.start()


func _on_Stun_timer_timeout() -> void:
	modulate = Color.white # Replace with function body.
	stun = false


func _on_Die_timer_timeout() -> void:
	dyingNow = true # Replace with function body.
