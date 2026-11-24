extends CharacterBody2D

#driving varibles
var max_speed = 900.0
var acceleration = 180.0
var brakeing = 250.0
var reverse_speed = 120.0
var steering_speed = 2.5
var friction = 120.0
var speed = 0.0
var tarmac_traction = 5.0
var dirt_traction = 3.0
var steering_speed_fix = 300
@onready var frontsensor = get_node("FrontSensor")
@onready var backsensor = get_node("BackSensor")

#main driving functions
func _physics_process(delta: float) -> void:
	var frontpixel = (frontsensor.global_position + Vector2(2758.5, 2758.5)) / 11.034
	if 0<=frontpixel.x && frontpixel.x<500 && 0<=frontpixel.y && frontpixel.y<500:
		print(frontpixel)
		if Input.is_action_pressed("accelerate") :
			speed -= acceleration * delta
			speed = clamp(speed, -max_speed, reverse_speed)
		elif Input.is_action_pressed("brake") :
			if speed < 0 :
				speed = move_toward(speed, 0, brakeing * delta)
			else :
				speed = move_toward(speed, reverse_speed, acceleration * delta)
		else :
			speed = move_toward(speed, 0, friction * delta)
		
		var steering_factor = clampf(abs(speed) / steering_speed_fix, 0.0, 1.0)
		if Input.is_action_pressed("steer_left") :
			rotation -= steering_speed * steering_factor * delta
		
		if Input.is_action_pressed("steer_right") :
			rotation += steering_speed * steering_factor * delta
		
		var direction = Vector2.UP.rotated(rotation)
		var forward_velocity = direction * -speed
		var sideways = Vector2(-direction.y, direction.x)
		var sideways_velocity = sideways * velocity.dot(sideways)
		sideways_velocity = sideways_velocity.lerp(Vector2.ZERO, tarmac_traction * delta) #PLACEHOLDER VALUE!!!! PLACEHOLDER VALUE!!!! PLACEHOLDER VALUE!!!! PLACEHOLDER VALUE!!!!
		velocity = forward_velocity + sideways_velocity
	else :
		print("off map: ", frontpixel)
	
	
	move_and_slide()
	print(speed)
	print(rotation)
