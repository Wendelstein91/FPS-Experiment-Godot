extends CharacterBody3D

# The velocity of the CharacterBody3D is in the global basis.
# Make controls relative to the Camera

@onready var grav = 9.81
@onready var cam = $Camera
@onready var jumpspeed = grav / 2

var body = self
var foreward = Vector3(0, 0, 1)
var left = Vector3(1, 0, 0)
var right = Vector3(-1, 0, 0)
var speed = 5
var zero_vector = Vector3(0,0,0)

var moving_ahead = false
var moving_left = false
var moving_right = false
var moving_back = false 
var motion = Vector3.ZERO

func _init():
	pass#velocity += global_transform.basis * foreward * speed

func _input(event):
		
	if event is InputEventMouseMotion:	
		
		cam.rotate_object_local(Vector3.LEFT, event.relative.y * 0.01) # Rotate Camera for looking up and down
		rotate_object_local(Vector3.DOWN, event.relative.x * 0.01) # Rotate Body for looking left and right
		velocity = velocity.rotated(Vector3.DOWN, event.relative.x * 0.01) # rotate velocity vector with mouse movement

	if event is InputEventKey:
		# Press Commands
		if Input.is_action_just_pressed("move_ahead") and not(moving_ahead):
			velocity += global_transform.basis * foreward * speed
			moving_ahead = true
			print("moving ahead")
		if Input.is_action_just_pressed("move_left") and not(moving_left):
			velocity += global_transform.basis * left * speed
			moving_left = true
			print("moving left")
		if Input.is_action_just_pressed("move_right") and not(moving_right):
			velocity += global_transform.basis * right * speed
			moving_right = true
			print("moving right")
		if Input.is_action_just_pressed("move_backwards") and not(moving_back):
			velocity -= global_transform.basis * foreward * speed
			moving_back = true
			print("moving back")
		
		# Release Commands
		if Input.is_action_just_released("move_ahead") and moving_ahead:
			velocity -= global_transform.basis * foreward * speed # set foreward direction zero, dont affect other directions
			moving_ahead = false
			print("stop ahead")
			
			
		if Input.is_action_just_released("move_left") and moving_left:
			velocity -= global_transform.basis * left * speed
			moving_left = false
			print("stop left")			
		if Input.is_action_just_released("move_right") and moving_right:
			velocity -= global_transform.basis * right * speed
			moving_right = false
			print("stop right")			
		if Input.is_action_just_released("move_backwards") and moving_back:
			velocity += global_transform.basis * foreward * speed
			moving_back = false
			print("stop back")		
		if Input.is_action_just_pressed("jump"):
			velocity.y += jumpspeed
			print("jumping")
	
func _physics_process(delta):
	# Apply Gravitational Force
	velocity.y -= grav * delta
	
	# Move Option 1
	# motion = velocity * delta
	# var col = move_and_collide(motion)
	
	# Move Option 2
	move_and_slide()
	
	print("wall:", is_on_wall(), "\t floor:", is_on_floor())
