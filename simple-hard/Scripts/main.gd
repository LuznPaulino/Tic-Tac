extends Node
var board_size: int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#When the game starts
	board_size = $Board.texture.get_width()
	print(board_size)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if event.position.x < board_size:
				print(event.position)
			
			
