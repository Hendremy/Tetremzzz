extends TileMap

@onready var main = $".."
@onready var game_over = $"../GameOver"
@onready var paused = $"../Paused"

@onready var pause_button = %PauseButton
@onready var hold = %Hold
@onready var next = %Next

@onready var score_value = %ScoreValue
@onready var lines_value = %LinesValue
@onready var level_value = %LevelValue

#const TetrominoFactory = preload("res://scripts/TetrominoFactory.gd")
const START_POS = Vector2i(4,0)
const BOARD_LAYER = 0
const PIECE_LAYER = 1
const SHADOW_LAYER = 2
const SOURCE_ID = 0
const DOWN = Vector2i(0,+1)
const LEFT = Vector2i(-1,0)
const RIGHT = Vector2i(+1,0)
const ROWS = 20
const COLS = 10
const LEVEL_LINE_NB = 10

var score = 0
var line_count = 0
var level = 1

var current_piece : Tetromino

var is_paused = false
var is_over = false

# Called when the node enters the scene tree for the first time.
func _ready():
	new_game()
	
func new_game():
	pause(true)
	erase_board()
	
	next.reset()
	hold.reset()
	
	set_game_over(false)
	
	update_level()
	update_score()
	update_lines()

	setup_new_piece()
	pause(false)
	
func set_game_over(yes:bool):
	game_over.visible = yes
	is_over = yes
	
func update_scoreboard(new_score, new_line_count):
	update_score(new_score)
	update_lines(new_line_count)
	
	if line_count > LEVEL_LINE_NB * level:
		update_level(level + 1)
	
func update_level(value = 1):
	level = value
	level_value.text = str(level)
	
func update_score(value = 0):
	score = value
	score_value.text = str(score)
	
func update_lines(value = 0):
	line_count = value
	lines_value.text = str(line_count)
	
func pause(yes: bool):
	pause_button.emit_signal("toggled", yes)

func erase_board():
	for i in range(0,COLS):
		for j in range(-1,ROWS):
			self.erase_cell(SHADOW_LAYER, Vector2i(i,j))
			self.erase_cell(BOARD_LAYER, Vector2i(i,j))
			self.erase_cell(PIECE_LAYER, Vector2i(i,j))
	
func setup_new_piece():
	if current_piece:
		_disconnect_piece_events()
		
	current_piece = next.pop_next_piece()
	_connect_piece_events()
	current_piece.activate(self, START_POS, PIECE_LAYER, BOARD_LAYER, SHADOW_LAYER, SOURCE_ID)
	
func _connect_piece_events():
	if current_piece:
		current_piece.piece_landed.connect(_on_piece_landed)
		current_piece.cannot_move.connect(_on_piece_cannot_move)

func _disconnect_piece_events():
	if current_piece:
		current_piece.disconnect("piece_landed", _on_piece_landed)
		current_piece.disconnect("cannot_move", _on_piece_cannot_move)

func score_lines():
	var scored_pts = 0
	var lines = get_full_lines()
	
	for line in lines:
		clear_line(line)
		scored_pts += 100 * level
	
	update_scoreboard(score + scored_pts, line_count + lines.size())
	
	for line in lines:
		shift_upper_rows(line)
	
func shift_upper_rows(line):
	for row in range(line-1, 1, -1):
		for col in range(0, COLS):
			var pos = Vector2i(col, row)
			var cell = get_cell_atlas_coords(BOARD_LAYER, pos)
			if cell:
				erase_cell(BOARD_LAYER, pos)
				set_cell(BOARD_LAYER, Vector2i(col, row + 1), SOURCE_ID, cell)

func clear_line(row):
	for col in range(0, COLS):
		erase_cell(BOARD_LAYER, Vector2i(col,row))

func get_full_lines():
	var lines = []
	for row in range(0,ROWS):
		var line_is_full = true
		for col in range(0,COLS):
			if get_cell_source_id(BOARD_LAYER, Vector2i(col,row)) == -1:
				line_is_full = false
		if line_is_full:
			lines.append(row)
	return lines

func _process(_delta):
	if is_over:
		return
	
	if Input.is_action_just_pressed("pause"):
		pause(!is_paused)
	
	if is_paused:
		return
	
	if Input.is_action_just_pressed("drop"):
		current_piece.drop(DOWN)
		
	if Input.is_action_just_pressed("rotate"):
		current_piece.rotate()
		
	if Input.is_action_just_pressed("hold"):
		if hold.can_swap:
			_disconnect_piece_events()
			current_piece.erase()
			
			var swapped = hold.swap_piece(current_piece)
			
			if swapped:
				current_piece = swapped
				current_piece.activate(self, START_POS, PIECE_LAYER, BOARD_LAYER, SHADOW_LAYER, SOURCE_ID)
			else:
				setup_new_piece()
				
			current_piece.draw()
			_connect_piece_events()

func _on_piece_landed():
	if not is_over:
		setup_new_piece()
		score_lines()
		hold.enable_swap()
	
func _on_piece_cannot_move():
	set_game_over(true)

func _on_move_timer_timeout():
	if is_paused or is_over:
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
		paused.visible = true
		pause_button.text = "Resume"
		main.get_node("FallTimer").stop()
		main.get_node("MoveTimer").stop()
	else:
		paused.visible = false
		pause_button.text = "Pause"
		main.get_node("FallTimer").start()
		main.get_node("MoveTimer").start()
	is_paused = toggled_on

func _on_exit_button_pressed():
	get_tree().quit()
