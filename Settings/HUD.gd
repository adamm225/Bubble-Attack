extends CanvasLayer

signal start_game

func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()

#maybe have a timer for when we call this function so create a timer
#and have game over call the timer and when we reach that then we display it
# so the real stuff will be in the timer
func show_game_over():
	show_message("Game Over")
	yield($MessageTimer, "timeout")
	$MessageLabel.text = "Bubble\nAttack!"
	$MessageLabel.show()
	yield(get_tree().create_timer(1), "timeout")
	Global.abilityToShoot = false
	$StartButton.show()


func update_score(score):
	$ScoreLabel.text = str(score)


func _on_StartButton_pressed():
	$StartButton.hide()
	Global.abilityToShoot = true
	emit_signal("start_game")


func _on_MessageTimer_timeout():
	$MessageLabel.hide()
