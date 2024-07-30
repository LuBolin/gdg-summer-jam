extends Control

@export var master_bus_name := "Master"
@onready var master_bus_index: int = AudioServer.get_bus_index(master_bus_name)

@onready var settings_button = %SettingsButton
@onready var master_volume_slider = %MasterVolumeSlider
@onready var settings_panel = %SettingsPanel

func _ready():
	settings_button.pressed.connect(toggle_settings_panel)
	master_volume_slider.value_changed.connect(modify_master_volume)
	
	sync_settings()

func modify_master_volume(value: float):
	AudioServer.set_bus_volume_db(
		master_bus_index,
		linear_to_db(value)
	)

func sync_settings():
	print(AudioServer.get_bus_volume_db(master_bus_index))
	master_volume_slider.value = db_to_linear(
		AudioServer.get_bus_volume_db(master_bus_index)
	)

func toggle_settings_panel():
	settings_panel.visible = \
		not settings_panel.visible

func _input(event):
	if event is InputEventKey \
		and event.keycode == KEY_ESCAPE \
		and event.is_pressed():
		toggle_settings_panel()
