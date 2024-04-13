extends CharacterBody2D

const SPEED = 300.0
const FLAP = -10000
const MAXFALLSPEED = 2000
const GRAVITY = 1000
const JUMP_VELOCITY = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var motion = Vector2.ZERO
var wall: PackedScene = preload("res://wallnode.tscn")

# Score & metrics variables
var credits = 0
var semesters = 1
var space_hits = 0

func _ready():
	get_parent().get_parent().get_node("GameOverMenu").hide()
	get_tree().paused = false

func increase_wall_speed(increase_amount: float) -> void:
	Global.wall_speed -= increase_amount

func _physics_process(delta: float) -> void:
	motion.y += GRAVITY
	if motion.y > MAXFALLSPEED:
		motion.y = MAXFALLSPEED
	
	if Input.is_action_just_pressed("FLAP"):
		$JumpAudio.play()
		motion.y = FLAP
		space_hits += 1
		
	self.velocity = motion 
	self.move_and_slide() 
	
	get_parent().get_parent().get_node("Credits/CreditsText").text = "Credits - " + str(credits)
	
func generate_new_level():
	var wall_inst = wall.instantiate()
	wall_inst.position = Vector2(3000, randi_range(-1000, 1000))
	get_parent().call_deferred("add_child", wall_inst)
	increase_wall_speed(10)
	semesters += 1
	get_parent().get_parent().get_node("Semesters/SemestersText").text = "Semesters - " + str(semesters)

# Detect "player passed all walls in semester successully"
# and new walls (level) needs to be generated
func _on_resetter_body_entered(body):
	if body.name == "Walls":
		body.queue_free()
		generate_new_level()

# Detect collission player - wall
func _on_detect_body_entered(body):
	if body.name.contains("Walls"):  
		displayGameOverMenu()

func displayGameOverMenu():
	get_parent().get_parent().get_node("GameOverMenu/TotalCredistsValue").text = str(credits)
	get_parent().get_parent().get_node("GameOverMenu/TotalSemestersValue").text = str(semesters)
	get_parent().get_parent().get_node("GameOverMenu/SpaceHitsValue").text = str(space_hits)
	get_parent().get_parent().get_node("GameOverMenu").show()
	get_tree().paused = true

# Add credit when player successfully leaves the "wall area"
func _on_detect_area_exited(area):
	if area.name == "PointArea":
		credits += 1

# Set default values when user clicks on the "restart" button
func _on_game_over_menu_restart():
	Global.wall_speed = -15
	get_tree().paused = false
	get_tree().reload_current_scene()
