extends MeshInstance

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$Particles.lifetime = max(self.translation.y, 0.01)
