extends RigidBody2D

var speed = 400

var velocity = Vector2()
var stunz = false
var posIHope = Vector2()
var whatevs = Vector2()
var playOnlyOnce = false
var dyingNow = false
var countToOne = 0
var startDirection = 0
#onready var _animated_sprite = $AnimatedSprite
var blood_particles = preload("res://Blood_particles.tscn")

#makes it so it is only set once
func _initialDirection() -> void:
	#posIHope =  global_position.direction_to(Global.player.global_position)
	#whatevs = posIHope
	velocity = global_position.direction_to(Global.player.global_position)
	rotation = velocity.angle()
	#got missle now angle it towards
	#we got the formula for shooting/direction at the player with the direction to	


#add in the area entered with explosion and leave a trail

func _physics_process(delta: float) -> void: #_process is original
	if startDirection == 0:
		_initialDirection()
		#rotation = velocity.angle()
		startDirection = 1
	
	#global_position += velocity * speed * delta
	global_position += velocity * speed * delta
	if Global.inGame == false:
		queue_free()

	if dyingNow  == true:
		queue_free()


func _on_hitBocx_area_entered(area: Area2D) -> void:
	#$Sprite.visible = false	
	if countToOne == 0:
		$deathTimer.start()
		countToOne = countToOne + 1

func _on_deathTimer_timeout() -> void:
	pass # Replace with function body.
