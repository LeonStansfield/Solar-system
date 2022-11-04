extends RigidBody

#references
onready var camera = $Camera_yaw/Camera_pitch/Camera

#physics
var G = 6.6743 * pow(10, -2)
export (Vector3) var initial_velocity = Vector3.ZERO

#movement
var gravity_direction = Vector3()

export var move_force = 30
export var max_speed = 10

var velocity = Vector3()

export var jump_force = 20
export var cyote_time = 0.15
var is_grounded

var mouse_sensitivity = 0.3
var camera_anglev = 0

func _ready():
	Globals.camera = camera
	Globals.player = self
	linear_velocity = initial_velocity
	Globals.celestial_bodies.append(self)

func _input(event):
	#mouse input for camera rotation
	if event is InputEventMouseMotion:
		$Camera_yaw.rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		var changev =- event.relative.y * mouse_sensitivity
		if camera_anglev + changev >- 50 and camera_anglev + changev < 50:
			camera_anglev += changev
			$Camera_yaw/Camera_pitch.rotate_x(deg2rad(changev))

func _process(delta):
	#pause
	if Globals.is_paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	_calc_gravity_direction()
	
	if $Ground_check.is_colliding():
		var obj = $Ground_check.get_collider()
		is_grounded = true
	else:
		yield (get_tree().create_timer(cyote_time), "timeout")
		is_grounded = false
	
	#_move()

func _physics_process(delta):
	Gravity(delta)

func Gravity(delta):
	for body in Globals.celestial_bodies:
		
		for otherbody in Globals.celestial_bodies:
			
			if otherbody != self:
				
				var otherbodyMass = otherbody.mass
				var direction = body.get_translation() - otherbody.get_translation()
				var distance = direction.length()
				
				var forceMag = G * (mass * otherbodyMass)
				var force = direction.normalized() * forceMag
				
				body.add_central_force(-force)


func _integrate_forces(state):
	_walk_around_planet(state)


func _calc_gravity_direction():
	#gets gravity direction and puts it in a variable
	var nearest_planet
	var distance_to_planet
	var prev_distance = 1000000
	
	for i in Globals.celestial_bodies:
		#find distance to planet planet
		distance_to_planet = self.global_transform.origin.distance_to(i.global_transform.origin)
		#if distance is smaller than the previous, set it to the nearest planet
		if distance_to_planet < prev_distance:
			nearest_planet = i
		
	gravity_direction = (nearest_planet.global_transform.origin - global_transform.origin).normalized()


func _walk_around_planet(state):
	# allign the players y-axis (up and down) with the planet's gravity direciton:
	state.transform.basis.y = -gravity_direction


func _move():
	#handles all input and logic related to character movement
	#move from input

	var dir = Vector3()
	var forward = Vector3.FORWARD
	forward = $Camera_yaw.transform.basis.y.normalized()

	if is_grounded:
		#movement
		var move_input = Vector2.ZERO

		move_input = Input.get_vector("left", "right", "forward", "back")
		dir += move_input.x * $Camera_yaw.global_transform.basis.x ;
		dir += move_input.y * $Camera_yaw.global_transform.basis.z ;

		#dir = dir * $Camera_yaw.global_transform.basis.x
		velocity = dir * move_force
		add_central_force(velocity)

		#jump:
		if Input.is_action_just_pressed("up"):
			apply_impulse(Vector3.UP, jump_force * global_transform.basis.y)


