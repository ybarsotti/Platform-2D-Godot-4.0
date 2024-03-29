extends Node2D

@onready var texture = $texture
@onready var area_sign = $area_sign
@onready var animation_player = $AnimationPlayer as AnimationPlayer

const lines : Array[String] = [
	"Olá, aventureiro!",
	"É muito bom vê-lo por aqui",
	"Espero que esteja preparado...",
	"Sua jornada está apenas...",
	"...COMEÇANDO!"
]

func _unhandled_input(event):
	if area_sign.get_overlapping_bodies().size() > 0:
		texture.show()
		if event.is_action_pressed("interaction") && !DialogManager.is_message_active:
			animation_player.stop()
			texture.hide()
			DialogManager.start_message(global_position, lines)
	else:
		texture.hide()
		animation_player.play("float")
		if DialogManager.dialog_box != null:
			DialogManager.dialog_box.queue_free()
			DialogManager.is_message_active = false
