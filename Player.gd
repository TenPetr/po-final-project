extends CharacterBody2D

const SPEED = 300.0
const FLAP = -10000
const MAXFALLSPEED = 2000
const GRAVITY = 1000
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var motion = Vector2.ZERO
var wall : PackedScene = preload("res://wallnode.tscn")
var score = 0 

func _physics_process(delta: float) -> void:
	motion.y += GRAVITY
	if motion.y > MAXFALLSPEED:
		motion.y = MAXFALLSPEED
	
	if Input.is_action_just_pressed("FLAP"):
		motion.y = FLAP
		
	self.velocity = motion # Set the body's velocity property
	self.move_and_slide() # Call move_and_slide with no parameters
	
	get_parent().get_parent().get_node("CanvasLayer/RichTextLabel").text = str(score)
	# Add the gravity.
	#if not is_on_floor():
		#velocity.y += gravity * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var direction = Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
#
	#move_and_slide()

func Wall_reset():
	var wall_inst = wall.instantiate()
	wall_inst.position = Vector2(3000, randi_range(-2500, 2500))
	get_parent().call_deferred("add_child", wall_inst)
	
func _on_resetter_body_entered(body):
	if body.name == "Walls":
		body.queue_free()
		Wall_reset()


func _on_detect_area_entered(area):
	if area.name == "PointArea":
		score = score + 1
		

#func _on_detect_body_entered(body):
	#if body.name == "Walls":     
		#get_tree().reload_current_scene()


