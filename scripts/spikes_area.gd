extends Area2D

@export var spike_count: int = 1
@onready var spikes = $spikes as Sprite2D
@onready var collision = $collision as CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	draw_spikes()
	draw_collision()
	
func draw_collision():
	collision.shape.size = spikes.get_rect().size

func draw_spikes():
	var region_rect = spikes.region_rect
	spikes.region_rect = Rect2(region_rect.position.x, region_rect.position.y, 8 * spike_count, region_rect.size.y)

func _on_body_entered(body):
	if body.name == "player" && body.has_method("take_damage"):
		body.take_damage(Vector2(0, -250))
		
