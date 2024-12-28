extends Node2D

const EXPLODE = preload("res://assets/explode.wav")

@export var gem_scene: PackedScene

@onready var label: Label = $Label
@onready var timer: Timer = $Timer
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var _score: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text = "%04d" % 0
	spawn_gem()
	
func stop_all() -> void:
	timer.stop()
	for child in get_children():
		child.set_process(false)
	
	audio_stream_player.stop()
	audio_stream_player.stream = EXPLODE
	audio_stream_player.play()
	
	
func game_over() -> void:
	stop_all()
	print("Game Over")

func increase_score(amount: int):
	_score += amount
	label.text = "%04d" % _score

func spawn_gem() -> void:
	var new_gem: Gem = gem_scene.instantiate()
	var xpos: float = randf_range(50, 1950)
	new_gem.position = Vector2(xpos, -50)
	new_gem.on_gem_off_screen.connect(game_over)
	add_child(new_gem)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_timer_timeout() -> void:
	spawn_gem()


func _on_paddle_area_entered(area: Area2D) -> void:
	increase_score(1)
	audio_stream_player_2d.position = area.position
	audio_stream_player_2d.play()
	area.queue_free()
