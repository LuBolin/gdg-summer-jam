extends Control

@export var master_bus_name := "Master"
@onready var master_bus_index: int = AudioServer.get_bus_index(master_bus_name)

@onready var settings_button = %SettingsButton
@onready var settings_panel = %SettingsPanel

@onready var master_volume_slider = %MasterVolumeSlider
@onready var yaw_sensitivity_slider = %YawSensitivitySlider
@onready var pitch_sensitivity_slider = %PitchSensitivitySlider

@onready var restart_btn = %RestartBtn
@onready var to_main_menu_btn = %ToMainMenuBtn

var prev_mouse_mode: Input.MouseMode = Input.MOUSE_MODE_VISIBLE

func _ready():
	settings_button.pressed.connect(toggle_settings_panel)
	master_volume_slider.value_changed.connect(modify_master_volume)
	yaw_sensitivity_slider.value_changed.connect(modify_yaw_sensitivity)
	pitch_sensitivity_slider.value_changed.connect(modify_pitch_sensitivity)
	
	sync_settings()
	restart_btn.pressed.connect(
		func(): 
			settings_panel.hide()
			Global.restart.emit()
	)
	to_main_menu_btn.pressed.connect(
		func():
			settings_panel.hide()
			Global.to_main_menu.emit()
	)

func modify_master_volume(value: float):
	AudioServer.set_bus_volume_db(
		master_bus_index,
		linear_to_db(value)
	)

func modify_yaw_sensitivity(value: float):
	PlayerCamera.yaw_sensitivity = value

func modify_pitch_sensitivity(value: float):
	PlayerCamera.pitch_sensitivity = value

func sync_settings():
	# print(AudioServer.get_bus_volume_db(master_bus_index))
	master_volume_slider.value = db_to_linear(
		AudioServer.get_bus_volume_db(master_bus_index)
	)
	yaw_sensitivity_slider.value = PlayerCamera.yaw_sensitivity
	pitch_sensitivity_slider.value = PlayerCamera.pitch_sensitivity

func toggle_settings_panel():
	settings_panel.visible = \
		not settings_panel.visible
	if settings_panel.visible:
		prev_mouse_mode = Input.get_mouse_mode()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(prev_mouse_mode)
	

func _input(event):
	if event is InputEventKey \
		and event.keycode == KEY_ESCAPE \
		and event.is_pressed():
		toggle_settings_panel()
