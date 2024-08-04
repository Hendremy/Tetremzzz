class_name TetrominoFactory extends Node

#const Tetromino = preload("res://scripts/Tetromino.gd")
var _board: TileMap

func _init(board : TileMap):
	_board = board

# Used to build the correct coordinates of the pieces rotations
#var grid = [
#		[0,0],[0,1],[0,2],[0,3],
#		[1,0],[1,1],[1,2],[1,3],
#		[2,0],[2,1],[2,2],[2,3],
#		[3,0],[3,1],[3,2],[3,3],
#	]

func create_set():
	var pieces = [
		create_i(), 
		create_j(), 
		create_l(), 
		create_o(), 
		create_s(), 
		create_t(), 
		create_z()
		]
	pieces.shuffle()
	return pieces

func create_i():
	var i_0 = [
		
		[1,0],[1,1],[1,2],[1,3],
	]
	var i_90 = [
					[0,2],
					[1,2],
					[2,2],
					[3,2]
	]
	var i_180 = [
		
		
		[2,0],[2,1],[2,2],[2,3],
	]
	var i_270 = [
			  [0,1],
			  [1,1],
			  [2,1],
			  [3,1]
	]
	var i =[i_0, i_90, i_180, i_270]
	return Tetromino.new(1,_board, i)

func create_j():
	var j_0 = [
		[0,0],
		[1,0],[1,1],[1,2]
	]
	var j_90 = [
			  [0,1],[0,2],
			  [1,1],
			  [2,1]
	]
	var j_180 = [
		
		[1,0],[1,1],[1,2]
				   ,[2,2]
	]
	var j_270 = [
			  [0,1],
			  [1,1],
		[2,0],[2,1]
	]
	var j = [j_0, j_90, j_180, j_270]
	return Tetromino.new(2,_board, j)

func create_l():
	var l_0 = [
					[0,2],
		[1,0],[1,1],[1,2]
	]
	var l_90 = [
			  [0,1],
			  [1,1],
			  [2,1],[2,2]
	]
	var l_180 = [
		[1,0],[1,1],[1,2],
		[2,0]
	]
	var l_270 = [
		[0,0],[0,1],
			  [1,1],
			  [2,1]
	]
	var l = [l_0, l_90, l_180, l_270]
	return Tetromino.new(3, _board, l)

func create_t():
	var t_0 = [
		
		[1,0],[1,1],[1,2]
			 ,[2,1]
	]
	var t_90 = [
			  [0,1],
		[1,0],[1,1],
			  [2,1]
	]
	var t_180 = [
			  [0,1],
		[1,0],[1,1],[1,2]
	]
	var t_270 = [
			  [0,1],
			  [1,1],[1,2],
			  [2,1]
	]
	var t = [t_0, t_90, t_180, t_270]
	return Tetromino.new(4, _board, t)

func create_s():
	var s_0 = [
			  [0,1],[0,2],
		[1,0],[1,1]
	]
	var s_90 = [
			[0,1],
			[1,1],[1,2]
				 ,[2,2]
	]
	var s_180 = [
		
			  [1,1],[1,2],
		[2,0],[2,1]
	]
	var s_270 = [
		[0,0],
		[1,0],[1,1]
			 ,[2,1]
	]
	var s = [s_0, s_90, s_180, s_270]
	return Tetromino.new(5, _board, s)
	
func create_z():
	var z_0=[
		[0,0],[0,1]
			 ,[1,1],[1,2]
	]
	var z_90=[
				  [0,2],
			[1,1],[1,2],
			[2,1],
	]
	var z_180 = [
		[1,0],[1,1]
			 ,[2,1],[2,2]
	]
	var z_270 = [
			  [0,1],
		[1,0],[1,1],
		[2,0]
	]
	var z = [z_0, z_90, z_180, z_270]
	return Tetromino.new(6, _board, z)
	
func create_o():
	var o_0 = [
		[0,0],[0,1],
		[1,0],[1,1],
	]
	var o = [o_0]
	return Tetromino.new(7, _board, o)
