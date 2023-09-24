extends RigidBody2D

func _ready():
	$AnimatedSprite.playing = true
	var mob_types = $AnimatedSprite.frames.get_animation_names()
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]

#connect the collisionshape to the moband if it does then play the animation
#of getting exploded (animation player format in player.gd
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

#could make these bubbles that pop when in contact and queue free
#with a timer
