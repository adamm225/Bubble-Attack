extends Node

export(PackedScene) var mob_scene

#enemies
var enemy_1 = preload("res://bubMob.tscn")
var enemy_2 = preload("res://missle.tscn")
var enemy_3 = preload("res://bubMobBoss.tscn")
var enemy_4 = preload("res://bobomb.tscn")


var missleCountS = 0
var boss1Count = 0
var randomBombC = 0


func _ready():
	randomize()
	$MainScreenMusic.play()
	Global.node_creation_parent = self

	
func _exit_tree():
	Global.node_creation_parent = null


func new_game():
	get_tree().call_group("mobs", "queue_free")
	Global.score = 0
	Global.inGame = true
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(Global.score)
	$HUD.show_message("Get Ready")
	$MainScreenMusic.stop() 
	$GameMusic.play()
	$Enemy_spawn_timer.start()
	
	#Reset Wait times		
	$missleTimer.set_wait_time(5)
	$MobTimer.set_wait_time(3)

func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$GameMusic.stop()
	$DeathSound.play() # Replace with function body
	$MainScreenMusic.play()
	$Enemy_spawn_timer.stop()
	$bombTimer.stop()
	Global.inGame = false

#this spawns a new mob everytime it is called
func _on_MobTimer_timeout():
	# Choose a random location on Path2D.
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.offset = randi()

	# Create a Mob instance and add it to the scene.
	#if it is at a certain score then add a couple new instances to it
	#could have an array of mobs and it could add 1 to array search each time
	#cannot add the same rare mob twice in a row
	var mob = mob_scene.instance()
	add_child(mob)
#maybe change rotation
	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2 #change rotation to 
	#match player global position such as we did earlier somewhere

	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position

	# Add some randomness to the direction.
	#
	#direction = use sin to find the angle in unit circle from where you are
	#randomly have the mobs point towards the user
	mob.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(rand_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	#change the wait time
	if Global.score  >= 25: #can start adding which mob
		$MobTimer.set_wait_time(1.5)
		#$MobTimer.set_wait_time()
	if Global.score >= 100:
		$missleTimer.set_wait_time(2)
	if Global.score >= 20 and randomBombC == 0:
		$bombTimer.start()
		$bombTimer.set_wait_time(4)
		randomBombC = 1
		#$bombTimer.start()
		#randomBombC = 1



func _on_ScoreTimer_timeout():
	Global.score += 1
	$HUD.update_score(Global.score)

func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _change_wait_time():
	pass


#simple way to spawn the enemies without mob Path
func _on_Enemy_spawn_timer_timeout() -> void:
	var enemy_position = Vector2(0,0)
	
	while enemy_position.x < 640 and enemy_position.x > - 80 or enemy_position.y < 360 and enemy_position.y > -45:
		enemy_position = Vector2(rand_range(-160,670),rand_range(-90, 390)) #change this range potentially


	Global.instance_node(enemy_1, enemy_position, self)
	if boss1Count > 0:
		boss1Count += 1
	#put it count and score thing so that every three times it will spawn at blank score
	if Global.score > 50 and boss1Count == 0: #crashes with bomb being blown in menu screen
		Global.instance_node(enemy_3, enemy_position, self)
		boss1Count +=1
		
	
	if boss1Count >= 4:
		boss1Count = 0		
	
	
	#var enemy_position2 = Vector2(0,0)
	
	#while enemy_position2.x < 640 and enemy_position2.x > - 80 or enemy_position2.y < 360 and enemy_position2.y > -45:
		#enemy_position2 = Vector2(rand_range(-160,670),rand_range(-90, 390)) #change this range potentially
	
	#Global.instance_node(enemy_2, enemy_position2, self)


func _on_missleTimer_timeout() -> void:
	# Add some randomness to the direction.
	var enemy_position2 = Vector2(0,0)
	
	while enemy_position2.x < 640 and enemy_position2.x > - 80 or enemy_position2.y < 360 and enemy_position2.y > -45:
		enemy_position2 = Vector2(rand_range(-160,670),rand_range(-90, 390)) #change this range potentially

	#enemy_2.angle_to(velocity)
	Global.instance_node(enemy_2, enemy_position2, self)
	


func _on_bombTimer_timeout() -> void:
	var enemy_position = Vector2(rand_range(50,450),rand_range(-20,50))#rand_range(10,50))
	#while enemy_position.x < 640 and enemy_position.x > - 80:
	#enemy_position = Vector2(100,100) #change this range potentially

	Global.instance_node(enemy_4, enemy_position, self)
