extends Node

static var ants_count = 20
static var working_ants = 0
static var ants = []

# список ресов (индекс - уровень)
static var anthill_updates = [25, 75, 200, 500]
static var anthill_level = 0
static var anthill_position = Vector2.ZERO

static var resources = 0

static func get_free_ants() -> int:
	return	ants_count - working_ants
