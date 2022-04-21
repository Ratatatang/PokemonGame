extends Node2D

const combatScenePath = "res://Combat/CombatScene.tscn"

var nextScene = "res://WorldMaps/PlayerHouse.tscn"
var playerLocation = Vector2(0,0)
var playerDirection = Vector2(0,0)

var player = null

var pokedex = File.new()
var movedex = File.new()

var ableToBattle = true

var playerPokemonList = [
	"",
	"",
	"",
	"",
	"",
	""
]

var enemy1 = null
var enemy2 = null

# base class for all pokemon. has names, stats and moves

class pokemon:
	
	var pokedexInfo
	
	var speciesName
	var displayName
	
	var baseStats
	
	var hp
	var atk
	var spAtk
	var def
	var spDef
	var speed
	
	var hpIV
	var atkIV
	var spAtkIV
	var defIV
	var spDefIV
	var speedIV
	
	var tempHp
	
	var movePP = {
		"move1PP" : 0,
		"move2PP" : 0,
		"move3PP" : 0,
		"move4PP" : 0,
	}
	
	var level
	
	var moves = {
		"move1": "",
		"move2": "",
		"move3": "",
		"move4": ""
	}
	
	var availableMoves = []
	var availableMovesTemp = []
	
	var healthBar
	
	var types = []
	
	func _init(newName, lv, instPokedex, instMovedex):
		
		self.speciesName = newName
		self.displayName = newName
		self.level = lv
		
		self.pokedexInfo = instPokedex.get("Pokedex").get(speciesName)
		var moveLvs = pokedexInfo.get("Moves").keys()
		
		self.baseStats = pokedexInfo.get("BaseStats")
		
		self.hpIV = round(rand_range(0, 31))
		self.atkIV = round(rand_range(0, 31))
		self.defIV = round(rand_range(0, 31))
		self.spAtkIV = round(rand_range(0, 31))
		self.spDefIV = round(rand_range(0, 31))
		self.speedIV = round(rand_range(0, 31))
		
		self.hp =  round((((2 * baseStats.get("hp") + hpIV + 0) * level)/100) + level + 10)
		self.atk = round((((2 * baseStats.get("atk") + atkIV + 0) * level)/100) + 5)
		self.def = round((((2 * baseStats.get("def") + defIV + 0) * level)/100) + 5)
		self.spAtk = round((((2 * baseStats.get("spAtk") + spAtkIV + 0) * level)/100) + 5)
		self.spDef = round((((2 * baseStats.get("spDef") + spDefIV + 0) * level)/100) + 5)
		self.speed = round((((2 * baseStats.get("speed") + speedIV + 0) * level)/100) + 5)
		
		self.tempHp = self.hp
		
		self.types = pokedexInfo.get("Types").duplicate(true)
		
		get_moves(moveLvs, instMovedex)
		
		instMovedex = null
		availableMovesTemp = []
		
		# this is fucking stupid.
		#(figures out what key values in the moves dictionary need to be appended to availableMoves)
		
		
	func get_moves(moveLvs, instMovedex):
		
		for i in range(len(moveLvs)):
			if(int(moveLvs[i]) <= self.level):
				var movesToAppend = pokedexInfo.get("Moves").get(moveLvs[i])
				for j in range(len(movesToAppend)):
					if self.availableMoves.find(movesToAppend[j]) <= 0:
						self.availableMoves.append(movesToAppend[j])
						print("added " + movesToAppend[j])
		
		self.availableMovesTemp = availableMoves.duplicate(true)
		
		# sets the amount of keys to set, and set a key to be a unique move
		# off the tempAvailableMoves list
		
		var keys = moves.keys()
		
		if len(keys) > len(availableMoves):
			keys.resize(len(availableMoves))
		
		var move = rand_range(0, len(availableMoves))
		move = round(move)
		
		for i in len(keys):
			move = rand_range(0, len(self.availableMovesTemp)-1)
			move = round(move)
			print(move)
			print(availableMovesTemp)
			self.moves[keys[i]] = self.availableMovesTemp[move]
			self.availableMovesTemp.erase(moves[keys[i]])
			self.moves[keys[i]] = instMovedex.get("Movedex").get(moves[keys[i]])
			self.movePP["move"+str(i+1)+"PP"] = self.moves[keys[i]].get("PP")
		
	func giveHealthBar(bar):
		self.healthBar = bar
		

# Makes sure that the colorRect for fading is clear, as well as getting pokedex and movedex 
# dictionaries from the pokedex.json and movedex.json files

func _ready():
	randomize()
	player = $CurrentScene.get_children().back().find_node("Player")
	$ScreenTransition/ColorFade.color =  Color(0, 0, 0, 0)
	$Menue/Menue.visible = false

	var pokedexFile = File.new()
	pokedexFile.open("Pokedex.json", File.READ)
	var pokedexFileData = JSON.parse(pokedexFile.get_as_text())
	pokedexFile.close()
	pokedex = pokedexFileData.result
	
	var movedexFile = File.new()
	movedexFile.open("Movedex.json", File.READ)
	var movedexFileData = JSON.parse(movedexFile.get_as_text())
	movedexFile.close()
	movedex = movedexFileData.result

	playerPokemonList[0] = pokemon.new("Bulbasaur", 4, pokedex, movedex)
	
# manages global inputs for stuff like the UI
	
func _process(delta):
	if(Input.is_action_just_pressed("openMenue") and !($CurrentScene.has_node("CombatScene"))):
		$Menue/Menue.visible = !($Menue/Menue.visible)
	
# The next functions are for the scene transition. transition_to_scene fades to black
# finished fading is called once the screen is black, and will clear the scene
# add the new one and move the player to the correct location

func transition_to_scene(newScene: String, spawnLocation, spawnDirection):
	nextScene = newScene
	$ScreenTransition/AnimationPlayer.play("FadeToBlack")
	playerDirection = spawnDirection
	playerLocation = spawnLocation

func finished_fading():
	$CurrentScene.get_child(0).queue_free()
	$CurrentScene.add_child(load(nextScene).instance())
	player = $CurrentScene.get_children().back().find_node("Player")
	player.set_spawn(playerLocation, playerDirection)
	$ScreenTransition/AnimationPlayer.play("FadeToClear")

# these 2 are basically just transitory functions

func noColorRect():
	$ScreenTransition/ColorFade.visible = false

func fade_from_combat():
	$ScreenTransition/ColorFade.visible = true
	$ScreenTransition/AnimationPlayer.play("FinishedCombatFade")

# for calling combat encounters
# callEncounter preps the enemy and sets the player to be frozen
# startEncounter is after the animation, it actually starts the scene and fades you into it

func callEncounter(pokemonName, lv):
	if(ableToBattle == true):
		$ScreenTransition/AnimationPlayer.play("WildCombatStart")
		player.external_set_state("freeze")
		player.frozen = true
		enemy1 = pokemonName
		enemy1 = pokemon.new(enemy1, lv, pokedex, movedex)
		print(enemy1)
		print(playerPokemonList[0])
		
func startEncounter():
	$CurrentScene.get_child(0).visible = false
	$CurrentScene.add_child(load(combatScenePath).instance())
	var combatScene = $CurrentScene.get_node("CombatScene")
	combatScene.getPokedex(pokedex, movedex)
	combatScene.set_mons("playerList", 0, playerPokemonList)
	combatScene.set_mons("enemy1", 0, enemy1)
	combatScene.StartBattle()
	combatScene.connect("finished_combat", self, "fade_from_combat")
	combatScene.connect("lose_combat", self, "lose_from_combat")
	$ScreenTransition/AnimationPlayer.play("FadeToCombat")

# clears the current combaat encounter and brings you back to the
# scene

func clear_combat():
	var combatScene = $CurrentScene.get_node("CombatScene")
	combatScene.queue_free()
	$CurrentScene.get_child(0).visible = true
	player = $CurrentScene.get_child(0).get_node("Player")
	player.frozen = false
	player.external_set_state("move")
	player.camera_set()
	$ScreenTransition/AnimationPlayer.play("FadeToClear")
	
# just for if you lose combat so you can't battle anymore

func lose_from_combat():
	ableToBattle = false
	fade_from_combat()
