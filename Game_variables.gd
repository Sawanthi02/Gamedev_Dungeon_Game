extends Node

var player_speed := 25
var enemy_speed := 8
var enemy_count := 10
var light_size := 45
var dungeon_size := 10
var tile_size := 4


var time := 0.0
var level := 1

func level_increas():
	level += 1
	if level % 10 == 0:
		enemy_count += 1
		enemy_speed -= 8
	if level % 2 == 0:
		enemy_speed +=2
	if level % 20 == 0:
		dungeon_size += 2
		light_size += 2
	if level % 5 == 0:
		light_size -= 2

func reset():
	level = 1
	player_speed = 25
	enemy_speed = 8
	enemy_count = 1
	light_size = 45
	dungeon_size = 10
	tile_size = 4
	time = 0.0
