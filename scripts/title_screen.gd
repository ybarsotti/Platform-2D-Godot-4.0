extends Control

@onready var audio_stream_player = $AudioStreamPlayer as AudioStreamPlayer

func _ready():
	audio_stream_player.play()
	Globals.coins = 0
	Globals.score = 0
	Globals.player_life = 3

func _on_start_btn_pressed():
	audio_stream_player.stop()
	get_tree().change_scene_to_file("res://levels/world_01.tscn")


func _on_credits_btn_pressed():
	audio_stream_player.stop()
	get_tree().change_scene_to_file("res://scenes/credits.tscn")

func _on_settings_btn_pressed():
	audio_stream_player.stop()
	get_tree().change_scene_to_file("res://scenes/settings.tscn")

func _on_quit_btn_pressed():
	audio_stream_player.stop()
	get_tree().quit()
