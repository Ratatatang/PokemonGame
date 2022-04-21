extends Area2D

export(Vector2) var spawnDirection = Vector2(0, 0)
export(Vector2) var spawnLocation = Vector2(0, 0)

export(String, FILE) var next_scene_path = ""

# connects the player node to the door 

func _ready():
	var player = find_parent("CurrentScene").get_children().back().find_node("Player")
	#player.connect("player_entering_door", self, "enter_door")

#Calls the function to transition the scene manager into the next scene 

func enter_door():
	print("Entered Door")
	get_node(NodePath("/root/SceneManager")).transition_to_scene(next_scene_path, spawnLocation, spawnDirection)

func _on_Door_area_entered(area):
	print("Entered Door")
	enter_door()
