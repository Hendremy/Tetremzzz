extends TileMap

const START_POS = Vector2i(0,0)
const ROWS = 3
const COLS = 4
const LAYER = 0
const SHADOW_LAYER = 1
const SOURCE_ID = 0

var current_piece : Tetromino
var can_swap = true

func swap_piece(piece:Tetromino):
	if not can_swap:
		return null
	
	var swapped = null
	if current_piece:
		swapped = current_piece
	
	_erase_hold()
	
	current_piece = piece
	current_piece.activate(self, START_POS, LAYER, LAYER, -1, SOURCE_ID)
	
	can_swap = false
	return swapped

func _erase_hold():
	for row in range(0, ROWS):
		for col in range(0, COLS):
			erase_cell(LAYER, Vector2i(col,row))
		
func enable_swap():
	can_swap = true
