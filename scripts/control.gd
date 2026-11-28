extends Control

func _on_accelerate_button_button_down() -> void:
	Input.action_press("accelerate")
func _on_accelerate_button_button_up() -> void:
	Input.action_release("accelerate")

func _on_brake_button_button_down() -> void:
	Input.action_press("brake")
func _on_brake_button_button_up() -> void:
	Input.action_release("brake")

func _on_steer_right_button_button_down() -> void:
	Input.action_press("steer_right")
func _on_steer_right_button_button_up() -> void:
	Input.action_release("steer_right")

func _on_steer_left_button_button_down() -> void:
	Input.action_press("steer_left")
func _on_steer_left_button_button_up() -> void:
	Input.action_release("steer_left")
