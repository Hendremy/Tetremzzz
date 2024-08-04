extends TileMap

#const TetrominoFactory = preload("res://scripts/TetrominoFactory.gd")
const START_POS = Vector2i(2,0)
const BOARD_LAYER = 0
const PIECE_LAYER = 1
const SOURCE_ID = 0
const DOWN = Vector2i(0,+1)
const LEFT = Vector2i(-1,0)
const RIGHT = Vector2i(+1,0)

var tetromino_factory : TetrominoFactory
var current_piece : Tetromino
var next_pieces = []
var next_pieces_buffer = []
var hold_piece

# Called when the node enters the scene tree for the first time.
func _ready():
	tetromino_factory = TetrominoFactory.new(self)
	next_pieces = tetromino_factory.create_set()
	next_pieces_buffer = tetromino_factory.create_set()

	setup_new_piece()
	
func setup_new_piece():
	current_piece = pop_next_piece()
	current_piece.activate(START_POS, PIECE_LAYER, BOARD_LAYER, SOURCE_ID)
	
func pop_next_piece() -> Tetromino:
	var p = next_pieces.pop_front()
	
	if next_pieces.size() == 0:
		next_pieces = next_pieces_buffer
		next_pieces_buffer = tetromino_factory.create_set()
		
	return p

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("down"):
		current_piece.move(DOWN)
	if Input.is_action_just_pressed("left"):
		current_piece.move(LEFT)
	if Input.is_action_just_pressed("right"):
		current_piece.move(RIGHT)
		
		
