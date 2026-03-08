extends Node

# BRINGS IN DIFFERENT SCENES INSTEAD OF LINKING
@export var circleScene: PackedScene
@export var crossScene: PackedScene

var player: int # PLAYER(S) CLICKS
var moves: int # COUNTING OVERALL MOVES
var tempMarker
var panPostion: Vector2i # DISPLAY NEXT MOVE
var gridDate: Array # GRID
var gridPosition: Vector2i # POSITIONS
var boardSize: int # BOARD
var cellSize: int # CELLS

# WIN CONDITION VARIABLES
var winner
var rowSum: int
var columnSum: int
var diagonal1Sum: int
var diagonal2Sum: int

func _ready() -> void:
	boardSize = $Board.texture.get_width()
	@warning_ignore("integer_division")
	cellSize = boardSize/3
	panPostion = $PlayerPanel.get_position()
	newGame()
	
@warning_ignore("unused_parameter")
func _process(delta):
	pass

# CHECKS THE INPUT OF CLICKS + GRIDLOCK POSITIONS
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			# CHECKING THE MOUSE IS ON THE BOARD
			if event.position.x < boardSize:
				# CONVERTING MOUSE.POSITION TO GRID LOCATION
				gridPosition = Vector2i(event.position / cellSize)
				if gridDate[gridPosition.y][gridPosition.x] == 0:
					moves += 1
					gridDate[gridPosition.y][gridPosition.x] = player
					# DISPLAYS THE NEXT PLAYING MARKER
					@warning_ignore("integer_division")
					createMarker(player, gridPosition * cellSize + Vector2i(cellSize/2, cellSize/2))
					if winCondition() != 0:
						get_tree().paused = true
						$GameOverMenu.show()
						if winner == 1:
							$GameOverMenu.get_node("ResultLabel").text = "Player 1 Wins"
						elif winner == -1:
							$GameOverMenu.get_node("ResultLabel").text = "Player 2 Wins"
					elif moves == 9:
						get_tree().paused = true
						$GameOverMenu.show()
						$GameOverMenu.get_node("ResultLabel").text = "It's a Tie"
					player *= -1
					# UPDATING DISPLAY MAKRER
					tempMarker.queue_free()
					@warning_ignore("integer_division")
					createMarker(player, panPostion + Vector2i(cellSize/2, cellSize/2), true)
					print(gridDate) 

#STARTS THE GAME BOARD ARRAY AT 0
func newGame():
	player = 1
	moves = 0
	winner = 0
	gridDate = [
		[0,0,0],
		[0,0,0],
		[0,0,0]
		]
	rowSum = 0
	columnSum = 0
	diagonal1Sum = 0 
	diagonal2Sum = 0
	# CLEAR EXISITNG CIRCLES + CROSSES
	get_tree().call_group("crosses", "queue_free")
	get_tree().call_group("circles", "queue_free")
	
	# CREATING MARKER TO SHOW WHO'S TURN IT IS
	@warning_ignore("integer_division")
	createMarker(player, panPostion + Vector2i(cellSize/2, cellSize/2), true)
	$GameOverMenu.hide()
	get_tree().paused = false


# MAKES THE X AND 0 APPEAR ON THE BOARD
@warning_ignore("shadowed_variable")
func createMarker(player, position, temp=false):
	if player == 1:
		var circle = circleScene.instantiate()
		circle.position = position
		add_child(circle)
		if temp: 
			tempMarker = circle
	if player == -1:
		var cross = crossScene.instantiate()
		cross.position = position
		add_child(cross)
		if temp: 
			tempMarker = cross


func winCondition():
	for i in len(gridDate):
		rowSum = gridDate[i][0] + gridDate[i][1] + gridDate[i][2]
		columnSum = gridDate[0][i] + gridDate[1][i] + gridDate[2][i]
		diagonal1Sum = gridDate[0][0] + gridDate[1][1] + gridDate[2][2]
		diagonal2Sum = gridDate[0][2] + gridDate[1][1] + gridDate[2][0]
		if rowSum == 3 or columnSum == 3 or diagonal1Sum == 3 or diagonal2Sum == 3:
			winner = 1
		elif rowSum == -3 or columnSum == -3 or diagonal1Sum == -3 or diagonal2Sum == -3:
			winner = -1
	return winner

func _on_game_over_menu_restart():
	newGame()
