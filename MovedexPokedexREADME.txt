Wondering how to add moves/pokemon? It's actually pretty simple

for moves, you have a few variables.
DisplayName, Type, PP, Accuracy and Category are simple enough. 

Power is just the base power of the move. 

Flags are the flags for abilities or items such as soundproof, or bulletproof. (List of flags below)

SpecialEffect is for special case moves. don't touch that unless you really know what you are doing

StatChanges is for status effects and stat changes. the scheme is
"StatChanges": {
    "Chance" : 
          "Target": "Target",
          "StatusEffect": "poison_1, confused, ect"
          "Stat (atk, def)": "number"	
}

important notes are that chance is rolled after the move has been decided if it hits, and that target is either Victim or Self, and victim is
all the targets of the move


for pokemon, the structure is way more simple.
(not finished enough to make documentation)



Movedex Structure - 

"poison_powder":{
            "DisplayName" : "Poison Powder",
            "Type": "Poison",
            "Power": 0,
            "PP": 35,
            "Accuracy": 75,
            "Category": "Status",
            "Flags": ["Powder"],
            "Target": "AdjacentFoe",
            "SpecialEffect": "",
            "StatChanges": {
                "100": {
                    "Target": "Victim",
                    "StatusEffect": "Poison_1"
                }
            }
        },

Pokedex Structure - 

"Bulbasaur" : {
            "ID": "001",
            "Types": ["Grass", "Poison"],
            "Moves": {
                "1": ["tackle", "growl"],
                "3": ["vine_whip"],
                "6": ["growth"],
                "9": ["leech_seed"],
                "12": ["razor_leaf"],
                "15": ["poison_powder"]
            },
            "EvoLv": 16,
            "EvoPokemon": "Ivysaur"
        },


