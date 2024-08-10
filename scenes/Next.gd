extends TileMap

const START_POS = [Vector2i(0,0), Vector2i(0,3), Vector2i(0,6)]
const ROWS = 8
const COLS = 4
const LAYER = 0
const SHADOW_LAYER = 1
const SOURCE_ID = 0

var tetromino_factory : TetrominoFactory
var next_pieces = []
var next_pieces_buffer = []
var current_pieces : Array

func _ready():
	reset()

func reset():
	tetromino_factory = TetrominoFactory.new()
	next_pieces = tetromino_factory.create_set()
	next_pieces_buffer = tetromino_factory.create_set()
	
	draw_next_three()

func draw_next_three():
	_erase_board()
	for i in range(0,3):
		var piece
		if i < next_pieces.size():
			piece = next_pieces[i]
		else:
			piece = next_pieces_buffer[ i - next_pieces.size()]
		piece.activate(self, START_POS[i], LAYER, LAYER, SHADOW_LAYER, SOURCE_ID)

func pop_next_piece() -> Tetromino:
	var p = next_pieces.pop_front()
	
	if next_pieces.size() == 0:
		next_pieces = next_pieces_buffer
		next_pieces_buffer = tetromino_factory.create_set()
	
	draw_next_three()
	
	return p

func _erase_board():
	for row in range(0, ROWS):
		for col in range(0, COLS):
			erase_cell(LAYER, Vector2i(col,row))

