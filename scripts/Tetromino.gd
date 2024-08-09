class_name Tetromino extends Node

signal piece_landed
signal cannot_move

var _id: int
var _rotations : Array
var _curr_rotation : int
var _board : TileMap
var _tile_coord : Vector2i
var _source_id : int

var _piece_layer
var _board_layer
var _shadow_layer
var _position
var _shadow_position
var _is_active = false

func _init(id: int, board : TileMap, rotations : Array):
	_id = id
	_board = board
	_rotations = convert_rotations(rotations)
	_curr_rotation = 0
	_tile_coord = Vector2i(id, 0)

func convert_rotations(rotations):
	var converted_rotations = []
	for r in rotations:
		var converted_r = []
		for a in r:
			converted_r.append(Vector2i(a[1],a[0]))
		converted_rotations.append(converted_r)
	return converted_rotations

func activate(start, piece_layer, board_layer, shadow_layer, source_id):
	_position = Vector2i(start)
	_shadow_position = Vector2i(_position)
	_piece_layer = piece_layer
	_board_layer = board_layer
	_shadow_layer = shadow_layer
	_source_id = source_id
	_is_active = true
	erase()
	draw()
	
	if not check_can_move(Vector2i(0,0)) and _position == _board.START_POS:
		emit_signal("cannot_move")

func move(direction : Vector2i):
	if check_can_move(direction):
		erase()
		_position += direction
		draw()
	else:
		if direction == _board.DOWN:
			erase(_piece_layer)
			draw(_board_layer)
			emit_signal("piece_landed")
		elif _position == _board.START_POS:
			emit_signal("cannot_move")
		
func drop(direction):
	while check_can_move(direction):
		move(direction)

func check_can_move(direction):
	var next_pos = calc_absolute_pos(_position + direction)
	return check_can_occupy(next_pos)

func check_can_occupy(pos):
	for cell in pos:
		if not _board.get_cell_source_id(_board_layer, cell) == -1:
			return false
	return true
	
func calc_absolute_pos(rel_pos = _position, rotation = _curr_rotation):
	var position = get_rotation(rotation)
	var nextPosition = position.duplicate()

	for i in range(nextPosition.size()):
		nextPosition[i] += rel_pos
	
	return nextPosition

func get_rotation(index = _curr_rotation) -> Array:
		return _rotations[ index % _rotations.size()]

func erase(layer = _piece_layer):
	var pos = calc_absolute_pos()
	for cell in pos:
		_board.erase_cell(layer, cell)
	
	erase_shadow()

func draw(layer = _piece_layer):
	var pos = calc_absolute_pos()
	for cell in pos:
		_board.set_cell(layer, cell, _source_id, _tile_coord)
		
	draw_shadow()
		
func draw_shadow():
	var offset = 0
	while check_can_move(Vector2i(0,offset)):
		offset += 1
	_shadow_position = Vector2i(_position + Vector2i(0,offset-1))
	
	var pos = calc_absolute_pos(_shadow_position)
	for cell in pos:
		_board.set_cell(_shadow_layer, cell, _source_id, _tile_coord + Vector2i(0,1))
		
func erase_shadow():
	for row in range(0, _board.ROWS + 1):
		for col in range(0, _board.COLS + 1):
			_board.erase_cell(_shadow_layer, Vector2i(col, row))

func rotate(clockwise = true):
	var offset = 1 if clockwise else -1
	var next_position = calc_absolute_pos(_position, _curr_rotation + offset)
	
	if check_can_occupy(next_position):
		erase()
		_curr_rotation += offset
		draw()
