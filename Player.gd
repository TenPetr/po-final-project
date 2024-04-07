extends CharacterBody2D

const SPEED = 300.0
const FLAP = -10000
const MAXFALLSPEED = 2000
const GRAVITY = 1000
const JUMP_VELOCITY = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var motion = Vector2.ZERO
var wall: PackedScene = preload("res://wallnode.tscn")
var score = 0 

func increase_wall_speed(increase_amount: float) -> void:
	Global.wall_speed -= increase_amount

func _physics_process(delta: float) -> void:
	motion.y += GRAVITY
	if motion.y > MAXFALLSPEED:
		motion.y = MAXFALLSPEED
	
	if Input.is_action_just_pressed("FLAP"):
		motion.y = FLAP
		
	self.velocity = motion 
	self.move_and_slide() 
	
	get_parent().get_parent().get_node("CanvasLayer/ScoreText").text = "Credits - " + str(score)
	
func generate_new_level():
	var wall_inst = wall.instantiate()
	wall_inst.position = Vector2(3000, randi_range(-1000, 1000))
	get_parent().call_deferred("add_child", wall_inst)
	increase_wall_speed(10)

# Detect "player passed all walls in semester successully"
# and new walls (level) needs to be generated
func _on_resetter_body_entered(body):
	if body.name == "Walls":
		body.queue_free()
		generate_new_level()

# Detect collission player - wall
func _on_detect_body_entered(body):
	if body.name.contains("Walls"):     
		get_tree().reload_current_scene()
		Global.wall_speed = -15

# Add credit when player successfully leaves the "wall area"
func _on_detect_area_exited(area):
	if area.name == "PointArea":
		score += 1
