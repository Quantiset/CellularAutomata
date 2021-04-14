extends Node2D

onready var tilemap = $TileMap

var tiles = {}

var brush_size = 3

var curr_type = 0

var set_monitor := false

func _draw():
	draw_rect(Rect2(Vector2(),Vector2(10,10)), Color())

func _input(event):
	if event is InputEventMouseButton:
		set_monitor = !set_monitor
	if Input.is_action_just_pressed("ui_up"):
		curr_type = 0
	if Input.is_action_just_pressed("ui_down"):
		curr_type = 1

func _process(delta):
	
	for tile in tilemap.get_used_cells():
		match tilemap.get_cell(tile.x, tile.y):
			0:
				inheritFall(tile, 0)
			1:
				inheritLiquid(tile, 1)
	
	if set_monitor:
		for x in range(brush_size*2):
			for y in range(brush_size*2):
				$TileMap.set_cell(get_local_mouse_position().x/2+x,get_local_mouse_position().y/2+y,curr_type)

func inheritFall(tile, idx):
	if tilemap.get_cell(tile.x, tile.y+1)==-1 and not is_out_of_bounds(tile.x, tile.y):
		tilemap.set_cell(tile.x, tile.y, -1)
		tilemap.set_cell(tile.x, tile.y+1, idx)
		return true
	elif tilemap.get_cell(tile.x-1, tile.y+1)==-1 and not is_out_of_bounds(tile.x, tile.y):
		tilemap.set_cell(tile.x, tile.y, -1)
		tilemap.set_cell(tile.x-1, tile.y+1, idx)
		return true
	elif tilemap.get_cell(tile.x+1, tile.y+1)==-1 and not is_out_of_bounds(tile.x, tile.y):
		tilemap.set_cell(tile.x, tile.y, -1)
		tilemap.set_cell(tile.x+1, tile.y+1, idx)
		return true
	return false

func inheritLiquid(tile, idx):
	if inheritFall(tile, idx):
		pass
	elif tilemap.get_cell(tile.x-1, tile.y)==-1 and not is_out_of_bounds(tile.x-1, tile.y) and randi()%2==0:
		tilemap.set_cell(tile.x, tile.y, -1)
		tilemap.set_cell(tile.x-1, tile.y, idx)
	elif tilemap.get_cell(tile.x+1, tile.y)==-1 and not is_out_of_bounds(tile.x+1, tile.y):
		tilemap.set_cell(tile.x, tile.y, -1)
		tilemap.set_cell(tile.x+1, tile.y, idx)

func is_out_of_bounds(x, y) -> bool:
	var area = OS.get_window_safe_area()
	if x>area.end.x/2:
		return true
	if x<area.position.x:
		return true
	if y>area.end.y/2:
		return true
	if y<area.position.y:
		return true
	return false
