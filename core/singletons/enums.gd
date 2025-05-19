extends Node

enum Target_characters {ENEMY, PLAYER}

const COLLISION_LAYERS = {
	Target_characters.ENEMY: {
		"collision_layer": 4,
		"collision_mask": 2
	},
	Target_characters.PLAYER: {
		"collision_layer": 1,
		"collision_mask": 8
	},
}
