extends Control

@onready var audio_stream_player = $AudioStreamPlayer as AudioStreamPlayer

func _ready():
	audio_stream_player.play()

func _on_back_btn_pressed():
	audio_stream_player.stop()
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")
