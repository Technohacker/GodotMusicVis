extends CanvasLayer

var MusicAPI

func _ready(): MusicAPI = get_tree().get_nodes_in_group("MusicAPI")[0]

func _input(event):
	if event.is_action_pressed("toggle_hud"):
		$HBoxContainer.visible = !$HBoxContainer.visible

func _on_Open_pressed():
	var file_open = FileDialog.new()
	file_open.mode = FileDialog.MODE_OPEN_FILE
	file_open.access = FileDialog.ACCESS_FILESYSTEM

	add_child(file_open)
	yield(get_tree(), "idle_frame")
	file_open.popup_centered(OS.window_size / 2)
	
	var file_path = yield(file_open, "file_selected")
	MusicAPI.add_song(file_path)

func _on_Clear_Playlist_pressed():
	MusicAPI.clear_queue()
	pass # Replace with function body.
