extends Control

@onready var start_btn = %StartBtn
@onready var anim_player = $AnimPlayer

func _ready():
	anim_player.play("FadeFromStarry")
	start_btn.pressed.connect(start_game)
	Global.to_main_menu.connect(enter_main_menu)

func start_game():
	start_btn.disabled = true
	anim_player.play("FadeToNothing")
	await anim_player.animation_finished
	hide()

func enter_main_menu():
	show()
	anim_player.play("FadeFromStarry")
	await anim_player.animation_finished
	start_btn.disabled = false
