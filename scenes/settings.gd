extends Control

@onready var button_scene = preload("res://scenes/settingsbutton.tscn")
@onready var v_box_container: VBoxContainer = $PanelContainer/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer
@onready var music_slider: HSlider = $PanelContainer/MarginContainer/VBoxContainer/VBoxContainer2/HBoxContainer/MusicSlider
@onready var sf_xslider: HSlider = $PanelContainer/MarginContainer/VBoxContainer/VBoxContainer2/HBoxContainer2/SFXslider

var is_remapping = false
var action_to_remap = null
var remapping_button = null

var input_actions = [
	"Pause", "Walk left", "Walk right", "Walk up", "Walk down"
]

func _ready() -> void:
	var keybindings = GameSetting.load_keybinding()
	for action in keybindings.keys():
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, keybindings[action])
	
	_create_action_list()
	var audio_settings = GameSetting.load_audio_setting()
	music_slider.value = min(audio_settings.master_volume, 1.0) * 100
	sf_xslider.value = min(audio_settings.sfx_volume, 1.0) * 100

func  _create_action_list():
	for item in v_box_container.get_children():
		item.queue_free()
	
	for action in input_actions:
		var button = button_scene.instantiate()
		var action_label = button.find_child("LabelAction")
		var input_label = button.find_child("LabelInput")
		
		action_label.text = action
		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			input_label.text = events[0].as_text().trim_suffix(" (Physical)")
		else:
			input_label.text = ""
		
		v_box_container.add_child(button)
		button.pressed.connect(_on_input_button_pressed.bind(button, action))

func _on_input_button_pressed(button, action):
	if !is_remapping:
		is_remapping = true
		action_to_remap = action
		remapping_button = button
		button.find_child("LabelInput").text = "Press key..."

func _input(event):
	if is_remapping:
		if event is InputEventKey:
			InputMap.action_erase_events(action_to_remap)
			InputMap.action_add_event(action_to_remap, event)
			GameSetting.save_keybinding(action_to_remap, event)
			_update_action_list(remapping_button, event)
			
			is_remapping = false
			action_to_remap = null
			remapping_button = null
			
			accept_event()

func _update_action_list(remapping_button, event):
	remapping_button.find_child("LabelInput").text = event.as_text().trim_suffix(" (Physical)")


func _on_music_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		GameSetting.save_audio_setting("master_volume", music_slider.value / 100)


func _on_sf_xslider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		GameSetting.save_audio_setting("sfx_volume", sf_xslider.value / 100)


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
