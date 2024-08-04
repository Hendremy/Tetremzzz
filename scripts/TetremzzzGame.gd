extends TileMap

@onready var main = $".."

#const TetrominoFactory = preload("res://scripts/TetrominoFactory.gd")
const START_POS = Vector2i(2,0)
const BOARD_LAYER = 0
const PIECE_LAYER = 1
const SOURCE_ID = 0
const DOWN = Vector2i(0,+1)
const LEFT = Vector2i(-1,0)
const RIGHT = Vector2i(+1,0)
const ROWS = 20
const COLS = 10

var tetromino_factory : TetrominoFactory
var current_piece : Tetromino
var next_pieces = []
var next_pieces_buffer = []
var hold_piece

# Called when the node enters the scene tree for the first time.
func _ready():
	new_game()
	
func new_game():
	erase_board()
	
	tetromino_factory = TetrominoFactory.new(self)
	next_pieces = tetromino_factory.create_set()
	next_pieces_buffer = tetromino_factory.create_set()

	setup_new_piece()

func erase_board():
	for i in range(1,COLS):
		for j in range(1,ROWS):
			self.erase_cell(BOARD_LAYER, Vector2i(i,j))
			self.erase_cell(PIECE_LAYER, Vector2i(i,j))
	
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
	if Input.is_action_just_pressed("drop"):
		current_piece.drop(DOWN)
		
	if Input.is_action_just_pressed("rotate"):
		current_piece.rotate()
		
	#if Input.is_action_just_pressed("hold"):
	#	emit_signal('hold_pressed')
	
func _on_move_timer_timeout():
	if Input.is_action_pressed("down"):
		current_piece.move(DOWN)
		
	if Input.is_action_pressed("left"):
		current_piece.move(LEFT)
		
	if Input.is_action_pressed("right"):
		current_piece.move(RIGHT)

func _on_fall_timer_timeout():
	current_piece.move(DOWN)

func _on_restart_button_pressed():
	new_game()

func _on_pause_button_toggled(toggled_on):
	if toggled_on:
		main.get_node("FallTimer").stop()
		main.get_node("MoveTimer").stop()
	else:
		main.get_node("FallTimer").start()
		main.get_node("MoveTimer").start()
