extends MeshInstance

export(Color) var COLOR = Color.white setget set_color

func set_color(color: Color):
	var mat = self.get_surface_material(0).duplicate()
	mat.albedo_color = color
	self.material_override = mat

	var process_material = ($Particles.process_material as ParticlesMaterial).duplicate()
	process_material.color = color
	$Particles.process_material = process_material
	COLOR = color

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
