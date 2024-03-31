extends EnemyBase

func _ready():
	anim.animation_finished.connect(kill_air_enemy)
