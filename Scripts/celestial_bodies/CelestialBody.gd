extends RigidBody

var G = 6.6743 * pow(10, -2)
export (Vector3) var initial_velocity = Vector3.ZERO
export (bool) var is_sun = false

func _ready():
	linear_velocity = initial_velocity
	Globals.celestial_bodies.append(self)

func _physics_process(delta):
	if !is_sun:
		Gravity(delta)
	else:
		linear_velocity = Vector3.ZERO

func Gravity(delta):
	#for body in Globals.celestial_bodies:
		
	for otherbody in Globals.celestial_bodies:
			
		if otherbody != self:
				
			var otherbodyMass = otherbody.mass
			var direction = self.get_translation() - otherbody.get_translation()
			var distance = direction.length()
				
			var forceMag = G * (mass * otherbodyMass)
			var force = direction.normalized() * forceMag
				
			add_central_force(-force)
