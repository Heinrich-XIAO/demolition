extends Node3D


var block_scene = preload("res://block.tscn")

var colors = [
	Color(1, 0, 0),       # Red
	Color(0, 0, 1),       # Blue
	Color(1, 1, 0),       # Yellow
	Color(0, 1, 0),       # Green
	Color(0.5, 0, 1),     # Purple
	Color(0, 1, 1),       # Cyan
	Color(1, 0, 1),       # Magenta
	Color(0.6, 0.3, 0.1), # Brown
	Color(0.1, 0.4, 0.1),        # Black
	Color(1, 0.5, 0),     # Orange
]

var blocks = []

func new_block(position: Vector3, is_fallen: bool, length: float, rotation: Vector3) -> RigidBody3D:
	var block = block_scene.instantiate()
	
	# Adjust collision shape
	block.get_children()[0].shape = BoxShape3D.new()
	block.get_children()[0].shape.size.x = length
	
	# Adjust mesh size and color
	block.get_children()[1].scale.x = length  # scale instead of mesh.size
	var mat = block.get_children()[1].get_active_material(0).duplicate()
	mat.albedo_color = colors[int(length-1)]
	block.get_children()[1].set_surface_override_material(0, mat)
	
	if not is_fallen:
		block.rotation.z = PI / 2
		block.position.y += length / 2
	
	block.position += position
	block.rotation += rotation
	return block

func move_camera_to_shoot():
	$Camera3D.position = Vector3(-40, 10, 0)
	$Camera3D.look_at(Vector3.UP*5)

func create_block_to_shoot(size: float) -> RigidBody3D:
	var the_new_block = new_block(Vector3(-20, 0, 0), true, size, Vector3(0, PI/2, 0))
	add_child(the_new_block)
	blocks.push_front(the_new_block)
	return the_new_block


func _ready() -> void:
	add_child(new_block(Vector3(10, 0, 0), false, 10.0, Vector3.ZERO))
	add_child(new_block(Vector3(0, 0, 0), true, 5.0, Vector3(0, PI/2, 0)))
	
	move_camera_to_shoot()
	create_block_to_shoot(2.0)
	blocks[0].apply_central_impulse(Vector3(30, 0, 0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
