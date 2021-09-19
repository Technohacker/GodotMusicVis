extends CanvasLayer

signal stream_ready(stream)

func _on_Open_pressed():
	var file_open = FileDialog.new()
	file_open.mode = FileDialog.MODE_OPEN_FILE
	file_open.access = FileDialog.ACCESS_FILESYSTEM

	add_child(file_open)
	yield(get_tree(), "idle_frame")
	file_open.popup_centered(OS.window_size / 2)
	
	var file_path = yield(file_open, "file_selected")
	var file = File.new()
	file.open(file_path, File.READ)
	var buffer = file.get_buffer(file.get_len())

	var stream = AudioStreamMP3.new()
	stream.data = buffer

	emit_signal("stream_ready", stream)
