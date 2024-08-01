extends Control

@onready var gif_rect: TextureRect = $GifRect
@onready var animation_player = $AnimationPlayer

@export var current_frame: int = 0
@export var total_frames: int = 24
var col_count = 5
var frame_size = Vector2(133, 75)
var won = false

func _ready():
	Global.victory.connect(victory)

func victory():
	if won:
		return
	self.show()
	won = true
	animation_player.play("VictoryGif")
	await animation_player.animation_finished
	Global.to_main_menu.emit()
	await get_tree().create_timer(0.2).timeout
	self.hide()
	won = false

func _process(delta):
	if not won:
		return
	var texture: AtlasTexture = gif_rect.get_texture()
	var x = current_frame % col_count
	var y = current_frame / col_count
	x *= frame_size.x
	y *= frame_size.y
	var rect: Rect2 = Rect2(Vector2(x, y), frame_size)
	texture.set_region(rect)
