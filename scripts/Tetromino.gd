class_name Tetromino extends Node

var _id: int
var _rotations : Array
var _curr_rotation : int
var _board : TileMap
var _tile_coord : Vector2i
var _source_id : int

var _piece_layer
var _board_layer
var _position
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

func activate(start, piece_layer, board_layer, source_id):
	_position = Vector2i(start)
	_piece_layer = piece_layer
	_board_layer = board_layer
	_source_id = source_id
	_is_active = true
	draw()

func move(direction : Vector2i):
	if check_can_move(direction):
		var prev_position = Vector2i(_position)
		_position += direction
		draw(prev_position, _position)

func check_can_move(direction):
	var next_pos = calc_absolute_pos(_position + direction)
	return check_can_occupy(next_pos)

func check_can_occupy(pos):
	for cell in pos:
		if not _board.get_cell_source_id(_board_layer, cell) == -1:
			return false
	return true
	
func calc_absolute_pos(rel_pos = _position):
	var position = get_current_rotation()
	var nextPosition = position.duplicate()

	for i in range(nextPosition.size()):
		nextPosition[i] += rel_pos
	
	return nextPosition

func get_current_rotation() -> Array:
	return _rotations[ _curr_rotation % _rotations.size()]

func draw(from = _position, to = _position):
	var from_abs = calc_absolute_pos(from)
	var to_abs = calc_absolute_pos(to)
	for cell in from_abs:
		_board.erase_cell(_piece_layer, cell)
	for cell in to_abs:
		_board.set_cell(_piece_layer, cell, _source_id, _tile_coord)

func rotate():
	pass
