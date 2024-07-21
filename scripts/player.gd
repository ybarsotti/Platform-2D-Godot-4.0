extends CharacterBody2D

const SPEED = 200.0
const AIR_FRICTION := 0.5
const COIN_SCENE := preload("res://prefabs/coin_rigid.tscn")

var is_jumping := false
var is_hurted := false
var knockback_vector := Vector2.ZERO
var knockback_power := 20
var direction

#handle jump ang gravity
@export var jump_height := 64
@export var max_time_to_peak := 0.5

var jump_velocity
var gravity
var fall_gravity

signal player_has_died()

@onready var animation := $anim as AnimatedSprite2D
@onready var remote_transform := $remote as RemoteTransform2D
@onready var jump_sfx = $jump_sfx as AudioStreamPlayer2D
@onready var destroy_sfx = preload("res://sounds/destroy_sfx.tscn")

func _ready():
	jump_velocity = (jump_height * 2 ) / max_time_to_peak
	gravity = (jump_height*2)/ pow(max_time_to_peak, 2)
	fall_gravity = gravity * 2

func _physics_process(delta):
	# TODO: Remove this temp fix for infinite fall
	if position.y > 120:
		queue_free()
		emit_signal("player_has_died")
	
	if not is_on_floor():
		velocity.x = 0

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		jump_sfx.play()
		velocity.y = -jump_velocity
		is_jumping = true
	elif is_on_floor():
		is_jumping = false

	if velocity.y > 0 or not Input.is_action_pressed("ui_accept"):
		velocity.y += fall_gravity * delta
	else:
		velocity.y += gravity * delta
	
	direction = Input.get_axis("ui_left", "ui_right")
	
	if direction:
		velocity.x = lerp(velocity.x, direction * SPEED, AIR_FRICTION)
		animation.scale.x = direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if knockback_vector != Vector2.ZERO:
		velocity = knockback_vector
	
	_set_state()
	move_and_slide()
	
	for platforms in get_slide_collision_count():
		var collision = get_slide_collision(platforms)
		if collision.get_collider().has_method("has_collided_with"):
			collision.get_collider().has_collided_with(collision, self)


func _on_hurtbox_body_entered(body: Node2D):	
	var knockback = Vector2((global_position.x - body.global_position.x) * knockback_power, -200)
	take_damage(knockback)
	if body.is_in_group("fireball"):
		body.queue_free()

func follow_camera(camera):
	var camera_path = camera.get_path()
	remote_transform.remote_path = camera_path

func take_damage(knockback_force := Vector2.ZERO, duration := 0.25):
	if Globals.player_life > 0:
		Globals.player_life -= 1
	
	if knockback_force != Vector2.ZERO:
		knockback_vector = knockback_force
		var knockback_tween := get_tree().create_tween().parallel()
		knockback_tween.tween_property(self, "knockback_vector", Vector2.ZERO, duration)
		animation.modulate = Color(1, 0, 0, 1)
		knockback_tween.tween_property(animation, "modulate", Color(1,1,1,1), duration)
	is_hurted = true
	await get_tree().create_timer(.3).timeout
	is_hurted = false
	if Globals.player_life < 1:
		queue_free()
		emit_signal("player_has_died")

func _set_state():
	var state = "idle"
	
	if !is_on_floor():
		state = "jump"
	elif direction != 0:
		state = "run"
	
	if is_hurted:
		state = "hurt"
	
	if animation.name != state:
		animation.play(state)
	
func _on_head_collider_body_entered(body):
	if body.has_method("break_sprite"):
		body.hitpoints -= 1
		if body.hitpoints < 0:
			body.create_coin()
			body.break_sprite()
			play_destroy_sfx()
		else:
			body.animation_player.play("hit")
			body.hit_block.play()
			body.create_coin()

func play_destroy_sfx():
	var sound_sfx = destroy_sfx.instantiate()
	get_parent().add_child(sound_sfx)
	sound_sfx.play()
	await sound_sfx.finished
	sound_sfx.queue_free()

