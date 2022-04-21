extends Node2D

export(int) var encounterRate = 0

onready var rootNode = find_parent("SceneManager")
onready var animationPlayer = $AnimationPlayer
	
# If theres a encounterList to be called, it will check a random chance and
# call an encounter in the scene manager passing along the encounterList

func _on_Area2D_body_entered(body):
	animationPlayer.play("Stepped")
	var encounter = randi() % 100 + 1
	if encounterRate >= encounter:
		rootNode.callEncounter("Bulbasaur", 4)
