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
var grass_traction = 4.0 
var current_traction = 5.0
var steering_speed_fix = 300
@onready var frontsensor = get_node("FrontSensor")
@onready var backsensor = get_node("BackSensor")

#Map variables
@onready var map_image = $"../Stage/stage".texture.get_image()
var front_pixel_color: Color
var back_pixel_color: Color

const ASPHALT_COLOR := Color(0.5216, 0.5216, 0.5216)
const DIRT_COLOR := Color(0.6118, 0.3529, 0.2353)
const GRASS_COLOR := Color(0.1333, 0.6941, 0.298)
const COLOR_TOLERANCE := 0.12
const OUTLINE_MAX := 0.15


func is_close(a: Color, b: Color, tol: float) -> bool:
	return abs(a.r - b.r) < tol and abs(a.g - b.g) < tol and abs(a.b - b.b) < tol


func is_outline(c: Color) -> bool:
	return c.r < OUTLINE_MAX and c.g < OUTLINE_MAX and c.b < OUTLINE_MAX


#main driving functions
func _physics_process(delta: float) -> void:
	var frontpixel = (frontsensor.global_position + Vector2(2758.5, 2758.5)) / 11.034
	var backpixel = (backsensor.global_position + Vector2(2758.5, 2758.5)) / 11.034
	if 0 <= frontpixel.x and frontpixel.x < 500 and 0 <= frontpixel.y and frontpixel.y < 500 and 0 <= backpixel.x and backpixel.x < 500 and 0 <= backpixel.y and backpixel.y < 500:
		print(frontpixel)

		# Read the map color under both sensors
		front_pixel_color = map_image.get_pixel(int(frontpixel.x), int(frontpixel.y))
		back_pixel_color = map_image.get_pixel(int(backpixel.x), int(backpixel.y))

		# Outline on either sensor: ignore it and keep the current grip
		# Only change grip when both sensors read the same surface
		if is_outline(front_pixel_color) or is_outline(back_pixel_color):
			pass
		elif is_close(front_pixel_color, ASPHALT_COLOR, COLOR_TOLERANCE) and is_close(back_pixel_color, ASPHALT_COLOR, COLOR_TOLERANCE):
			current_traction = tarmac_traction
		elif is_close(front_pixel_color, DIRT_COLOR, COLOR_TOLERANCE) and is_close(back_pixel_color, DIRT_COLOR, COLOR_TOLERANCE):
			current_traction = dirt_traction
		elif is_close(front_pixel_color, GRASS_COLOR, COLOR_TOLERANCE) and is_close(back_pixel_color, GRASS_COLOR, COLOR_TOLERANCE):
			current_traction = grass_traction

		if Input.is_action_pressed("accelerate"):
			speed -= acceleration * delta
			speed = clamp(speed, -max_speed, reverse_speed)
		elif Input.is_action_pressed("brake"):
			if speed < 0:
				speed = move_toward(speed, 0, brakeing * delta)
			else:
				speed = move_toward(speed, reverse_speed, acceleration * delta)
		else:
			speed = move_toward(speed, 0, friction * delta)

		var steering_factor = clampf(abs(speed) / steering_speed_fix, 0.0, 1.0)
		if Input.is_action_pressed("steer_left"):
			rotation -= steering_speed * steering_factor * delta

		if Input.is_action_pressed("steer_right"):
			rotation += steering_speed * steering_factor * delta

		var direction = Vector2.UP.rotated(rotation)
		var forward_velocity = direction * -speed
		var sideways = Vector2(-direction.y, direction.x)
		var sideways_velocity = sideways * velocity.dot(sideways)
		sideways_velocity = sideways_velocity.lerp(Vector2.ZERO, current_traction * delta)
		velocity = forward_velocity + sideways_velocity

	move_and_slide()
