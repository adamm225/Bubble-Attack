extends RigidBody2D

#variables
#can have different bombs have different things
var velocity = Vector2(0,150)
var speed = 1
var trashCount = 0
var exploding = false
var bombText = 3
#Grow x
var xRec = 30
var addRec = 1
#grow Sprite
var GRec = .37
var addGRec = 0.008
#sprite visible explosion
var trashCount2 = 0
var exploding2 = false
	
#random wait time and display the time on there
#	global_position += velocity * speed *delta
#make it so when waiting to explode is there then velocity = 0
#now just get the animation to play and we are good
#can also change the speed at which it grows and how big it gets with timer
#and the dimensions we set/add by everytime its called
func _physics_process(delta: float) -> void:
	#gravity_scale = 0
	#$waitingToExplode.set_wait_time(1)
	#$waitingToExplode.set_wait_time(3)
	if Global.inGame == false:
		queue_free()

	if trashCount2 == 0:
		$CollisionShape2D.shape.radius = 30
		$Area2D/CollisionShape2D.shape.radius = 30
		$exploPic.visible = false
		$waitingToExplode.wait_time = 5
		$waitingToExplode.set_wait_time(5)
		_tryingToChangeTime()
		#$waitingToExplode.set_wait_time(4)
		trashCount2 = 1
	if exploding == false:
		$CollisionShape2D.shape.radius = 30
		$Area2D/CollisionShape2D.shape.radius = 30
	global_position += velocity * delta
	#trash count is never called
	if trashCount == 0:
		$AnimationPlayer.play("waitingToEx")
		trashCount = 1
	#velocity.y +=  delta 
	#if hit then stop animation and play blood particles and extend
	if exploding and trashCount == 1:
		exploding2 = true
		$Sprite.visible = false
		$explode.start()
		trashCount = 2
	
	if exploding and exploding2:
		#queue_free()
		#get parent
		#set gravity scale of parent to it not just var whatever
		_weGrowing()
		#queue_free()
	#use the explosiveTing animation here as well as growing the circle/collision shape
	#to be used
	#global_position += velocity * speed * delta
	#maybe rename collisionShape
	#for kinematicbody2D
	#var motion = velocity * delta
	#move_and_collide(motion)

#use particles to replicate an explosion when it is taken off
#can make the bomb sprite invisible but the particles still there
#out.y += gravity * get_physics_process_delta_time()

#speed * GRAVITY * delta


func _tryingToChangeTime() -> void:
	$waitingToExplode.wait_time = 5
	$waitingToExplode.set_wait_time(5)


func _on_waitingToExplode_timeout() -> void:
	exploding = true
	velocity.y = 0
	$exploPic.visible = true


func _weGrowing() -> void:
	if exploding == true and exploding2 == true:
		if xRec < 600 and velocity.y == 0:
			$exploPic.scale = Vector2(GRec,GRec) #this works but the explosion needs to be changed
			$CollisionShape2D.shape.radius = xRec #the only way its making a difference
			#$CollisionShape2D.shape.extents = Vector2(xRec,yRec)
			xRec+=addRec
			GRec+=addGRec
		else:
			$CollisionShape2D.shape.radius = xRec #the only way its making a difference





func _on_explode_timeout() -> void:
	queue_free()


func _on_Area2D_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
	#could make it explode here as well
	#stop waiting to explode
	#call explode



func _on_waitingToExplode_ready() -> void:
	$waitingToExplode.set_wait_time(5) # Replace with function body.


func _on_exploLabTimer_timeout() -> void:
	bombText -= 1
	$timeLabel.text = str(bombText)
	if bombText == 0:
		$timeLabel.visible = false
