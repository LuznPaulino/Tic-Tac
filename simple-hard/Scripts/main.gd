extends Node

# BRINGS IN DIFFERENT SCENES INSTEAD OF LINKING
@export var circleScene: PackedScene
@export var crossScene: PackedScene


var player: int # PLAYER(S) CLICKS
var gridDate: Array # GRID
var gridPosition: Vector2i # POSITIONS
var boardSize: int # BOARD
var cellSize: int # CELLS

func _ready() -> void:
	boardSize = $Board.texture.get_width()
	cellSize = boardSize/3
	newGame()
	
func _process(delta: float) -> void:
	pass

# CHECKS THE INPUT OF CLICKS + GRIDLOCK POSITIONS
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if event.position.x < boardSize:
				gridPosition = Vector2i(event.position / cellSize)
				if gridDate[gridPosition.y][gridPosition.x] == 0:
					gridDate[gridPosition.y][gridPosition.x] = player
					createMarker(player, gridPosition * cellSize + Vector2i(cellSize/2, cellSize/2))
					player *= -1
					print(gridDate) 

#STARTS THE GAME BOARD ARRAY AT 0
func newGame():
	player = 1
	gridDate = [[0,0,0],
				[0,0,0],
				[0,0,0]
				]

# MAKES THE X AND 0 APPEAR ON THE BOARD
func createMarker(player, position):
	if player == 1:
		var circle = circleScene.instantiate()
		circle.position = position
		add_child(circle)
	if player == -1:
		var cross = crossScene.instantiate()
		cross.position = position
		add_child(cross)
