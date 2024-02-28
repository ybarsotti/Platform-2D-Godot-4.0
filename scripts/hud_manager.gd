extends Control

@onready var coins_counter = $container/coins_container/coins_counter as Label
@onready var timer_counter = $container/timer_container/timer_counter as Label
@onready var score_counter = $container/score_container/score_counter as Label
@onready var life_counter = $container/life_container/life_counter as Label

func _ready():
	coins_counter.text = str("%04d" % Globals.coins)
	score_counter.text = str("%06d" % Globals.score)

func _process(delta):
	coins_counter.text = str("%04d" % Globals.coins)
	score_counter.text = str("%06d" % Globals.score)
