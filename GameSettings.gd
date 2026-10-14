extends Node

var config = ConfigFile.new()
const SETTINGS_FILE_PATH = "user://settings.ini"

func _ready() -> void:
	if not FileAccess.file_exists(SETTINGS_FILE_PATH):
		config.set_value("keybinding", "Walk left", "A")
		config.set_value("keybinding", "Walk right", "D")
		config.set_value("keybinding", "Walk up", "W")
		config.set_value("keybinding", "Walk down", "S")
		config.set_value("keybinding", "Pause", "Escape")
		config.set_value("keybinding", "Pause", "")
		
		config.set_value("audio", "master_volume", 1.0)
		config.set_value("audio", "sfx_volume", 1.0)
		
		config.save(SETTINGS_FILE_PATH)
	else:
		config.load(SETTINGS_FILE_PATH)
	
	remap_keys()


func save_audio_setting(key: String, value):
	config.set_value("audio", key, value)
	config.save(SETTINGS_FILE_PATH)


func load_audio_setting():
	var audio_settings = {}
	for key in config.get_section_keys("audio"):
		audio_settings[key] = config.get_value("audio", key)
	return audio_settings


func remap_keys():
	var keys = config.get_section_keys("keybinding")
	for key in keys:
		if InputMap.has_action(key):
			InputMap.action_erase_events(key)
	
	print(InputMap.action_get_events("Walk up"))
	
	for key in keys:
		var event_str = config.get_value("keybinding", key)
		key = key.trim_suffix("2")
		if event_str != "":
			var input_event = InputEventKey.new()
			input_event.keycode = OS.find_keycode_from_string(event_str)
			InputMap.action_add_event(key, input_event)
	
	print(InputMap.action_get_events("Walk up"))


func save_keybinding(action: StringName, event: InputEvent):
	var event_str
	if event is InputEvent:
		event_str = OS.get_keycode_string(event.physical_keycode)
	config.set_value("keybinding", action, event_str)
	config.save(SETTINGS_FILE_PATH)

func load_keybinding():
	var keybindings = {}
	var keys = config.get_section_keys("keybinding")
	for key in keys:
		var input_event
		var event_str = config.get_value("keybinding", key)
		
		input_event = InputEventKey.new()
		input_event.keycode = OS.find_keycode_from_string(event_str)
		
		keybindings[key] = input_event
	return keybindings
		
