extends Area2D

var closestObject = null
var closestDistance = Vector2(0, 0)

func _process(delta):
	var interactableObjects = get_overlapping_areas()
	for i in len(interactableObjects):
		if(interactableObjects[i] != "InteractionBox"):
			interactableObjects.erase(i)
			
	for j in len(interactableObjects):
		var object = interactableObjects[j]
		var distance = object.get_global_transform().origin.distance_to()
