extends RigidBody2D

var speed = 200

var velocity = Vector2()
var stunz = false
var hp = 14
var invincibiltyBoss = false
#different color bubmobs witha different velocity and lives for them

var playOnlyOnce = false
var dyingNow = false
var countToOne = 0
var randCountToOne = 0
onready var _animated_sprite = $AnimatedSprite
var blood_particles = preload("res://Blood_particles.tscn")

#we got the formula for shooting/direction at the player with the direction to
func _physics_process(delta: float) -> void: #_process is original
	_animated_sprite.play()
	if Global.player != null and stunz == false:
		velocity = global_position.direction_to(Global.player.global_position)
	elif stunz:
		velocity = lerp(velocity, Vector2(0,0), 0.3)
	
	global_position += velocity * speed *delta
	if Global.inGame == false:
		queue_free()
	if velocity.x != 0 and stunz == false: #incorperate if knockback is not true
		$AnimatedSprite.flip_h = velocity.x < 0
	if hp <= 0:
		#$Pop.play()
		if Global.node_creation_parent != null and countToOne < 1:
			$CollisionShape2D.disabled = true
			$weHit/CollisionShape2D.disabled = true
			#.visible  = false
			#$.visible = false
			countToOne += 1
			var blood_particles_instance = Global.instance_node(blood_particles, global_position, Global.node_creation_parent)
			blood_particles_instance.rotation = velocity.angle()
			#play explosion
			Global.score += 5
			if countToOne == 1:
				_playsSong()
				countToOne += 1
			
		if dyingNow  == true:
			queue_free() #just for now
	#if Global.player != null and stun == false:
#call an animation player which keeps on looping but do it like a natural bubble loop
#have the bubble make a tiny trail
#make a if hitbox entered later so that it acts similar to the buble



#use area.is_in_group("Area2D") then do something specific
#this can be used to identify the specific node/enemy deteacter
#so make sure you keep this in min

func _on_stun_timer_timeout() -> void:
	modulate = Color.white 
	stunz = false 

func _playsSong()->void:
	#
	$popSound.play()
	$die_timer.start()
	#$popSound.stop()


func _on_weHit_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemy_damager") and stunz == false:
		modulate = Color.red
		velocity = -velocity * 2
		hp -=1	
		if hp == 0:                                                        
			$AnimatedSprite.visible = false
		#$Pop.stop()
		stunz = true
		$stun_timer.start()
		area.get_parent().queue_free() 


func _on_die_timer_timeout() -> void:
	dyingNow = true 
