extends Control

@onready var start_btn = %StartBtn
@onready var anim_player = $AnimPlayer

func _ready():
	anim_player.play("FadeFromStarry")
	start_btn.pressed.connect(start)

func start():
	if anim_player.get_current_animation() != "":
		return
	anim_player.play("FadeToNothing")
	await anim_player.animation_changed
	hide()
