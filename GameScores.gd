extends Node

const SCORES_FILE_PATH = "user://player_scores.json"
var scores = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	LoadScores()

func LoadScores():
	if FileAccess.file_exists(SCORES_FILE_PATH):
		print("there is a file")
		var file = FileAccess.open(SCORES_FILE_PATH, FileAccess.READ)
		var content = JSON.parse_string(file.get_as_text())
		if content:
			scores = content
		file.close()
		

func SaveScore(player_name, score, time):
	scores.append({
		"name" : player_name,
		"score" : score,
		"time" : time
	})
	var file = FileAccess.open(SCORES_FILE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(scores))
	file.close()

func LoadScoresSorted():
		scores.sort_custom(compare)
		return scores

func compare(a, b) -> bool:
	if a["score"] > b["score"]:
		return true
	else:
		return false
