extends TileMap

@onready var main = $".."
@onready var pause_button = $"../PauseButton"

#const TetrominoFactory = preload("res://scripts/TetrominoFactory.gd")
const START_POS = Vector2i(5,0)
const BOARD_LAYER = 0
const PIECE_LAYER = 1
const SOURCE_ID = 0
const DOWN = Vector2i(0,+1)
const LEFT = Vector2i(-1,0)
const RIGHT = Vector2i(+1,0)
const ROWS = 20
const COLS = 10

var score = 0
var line_count = 0
var tetromino_factory : TetrominoFactory
var current_piece : Tetromino
var next_pieces = []
var next_pieces_buffer = []
var hold_piece
var is_paused = false

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
	for i in range(1,COLS+1):
		for j in range(1,ROWS):
			self.erase_cell(BOARD_LAYER, Vector2i(i,j))
			self.erase_cell(PIECE_LAYER, Vector2i(i,j))
	
func setup_new_piece():
	if current_piece:
		current_piece.disconnect("piece_landed", _on_piece_landed)
	current_piece = pop_next_piece()
	current_piece.piece_landed.connect(_on_piece_landed)
	current_piece.activate(START_POS, PIECE_LAYER, BOARD_LAYER, SOURCE_ID)
	
func pop_next_piece() -> Tetromino:
	var p = next_pieces.pop_front()
	
	if next_pieces.size() == 0:
		next_pieces = next_pieces_buffer
		next_pieces_buffer = tetromino_factory.create_set()
		
	return p

func score_lines():
	var scored_pts = 0
	var lines = get_full_lines()
	for line in lines:
		clear_line(line)
		scored_pts += 100
	
	line_count += lines.size() 
	score += scored_pts

func clear_line(y):
	for x in range(1, COLS + 1):
		erase_cell(BOARD_LAYER, Vector2i(x,y))

func get_full_lines():
	var lines = []
	for y in range(1,ROWS):
		var line_is_full = true
		for x in range(1,COLS + 1):
			if get_cell_source_id(BOARD_LAYER, Vector2i(x,y)) == -1:
				line_is_full = false
		if line_is_full:
			lines.append(y)
	return lines

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if is_paused:
		return
	
	if Input.is_action_just_pressed("drop"):
		current_piece.drop(DOWN)
		
	if Input.is_action_just_pressed("rotate"):
		current_piece.rotate()
		
	#if Input.is_action_just_pressed("hold"):
	#	emit_signal('hold_pressed')

func _on_piece_landed():
	setup_new_piece()
	score_lines()

func _on_move_timer_timeout():
	if is_paused:
		return
	
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
		pause_button.text = "Resume"
		main.get_node("FallTimer").stop()
		main.get_node("MoveTimer").stop()
	else:
		pause_button.text = "Pause"
		main.get_node("FallTimer").start()
		main.get_node("MoveTimer").start()
	is_paused = toggled_on
