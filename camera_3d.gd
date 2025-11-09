extends Camera3D

var sensitivity: float = 0.003

func _ready() -> void:
	look_at(Vector3.ZERO, Vector3.UP)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if position.z != 0:
		return

	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * sensitivity)
		var ry = rotation_degrees.y

		if ry > 180:
			ry -= 360

		ry = clamp(ry, -105, -75)

		rotation_degrees.y = ry
		print(ry)

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
