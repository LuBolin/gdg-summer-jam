extends Control

@onready var start_btn = %StartBtn
@onready var anim_player = $AnimPlayer

func _ready():
	anim_player.play("FadeFromStarry")
	start_btn.pressed.connect(request_start_game)
	Global.to_main_menu.connect(enter_main_menu)

func request_start_game():
	start_btn.disabled = true
	anim_player.play("FadeToNothing")
	await anim_player.animation_finished
	Global.request_start_game.emit()
	hide()

func enter_main_menu():
	show()
	if Global.game_world:
		await Global.end_game()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	anim_player.play("FadeFromStarry")
	await anim_player.animation_finished
	start_btn.disabled = false
