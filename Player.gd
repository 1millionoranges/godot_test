extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const MAX_FLOOR_SPEED = 100
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var launching_rope_scene: PackedScene
@export var rope_speed = 100

func _physics_process(delta):

	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
#  t
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_VELOCITY
		if Input.is_action_pressed("go-left"):
			velocity.x -= SPEED
		if Input.is_action_pressed("go-right"):
			velocity.x += SPEED
		if abs(velocity.x) > MAX_FLOOR_SPEED:
			velocity.x *= 0.7
		else:
			velocity.x *= 0.9
	move_and_slide()
	
func launch_rope():
	var rope = launching_rope_scene.instantiate()
	var target = get_local_mouse_position()
	rope.launch(rope.target.normalized() * rope_speed)
	$Ropes.add_child(rope)
	
func ropes_process(delta):
	var push = Vector2.ZERO
	for rope in $Ropes.get_children():
		push = rope.do_calculation()
		if push:
			velocity += push
