extends Label

var game: Game

func _ready():
	game = owner

func _process(delta):
	text = str(game.draw_pile.size())
