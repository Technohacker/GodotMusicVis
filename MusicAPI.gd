# Music API
# The music is played and controlled here

extends Node

signal stream_ready(stream)
signal stop_stream()

var playlist: Array = []
var playing_music: bool = false
var wait_for_track: bool = true

func add_song(song_path: String):
	playlist.append(song_path)
	if !playing_music:
		_play_music()

func _play_music():
	playing_music = true
	for song in playlist:
		stream_music(song)
		if wait_for_track:
			yield(get_parent(), "track_finished")
	playing_music = false
	
func stream_music(song_path):
	var file = File.new()
	file.open(song_path, File.READ)
	var buffer = file.get_buffer(file.get_len())
	
	var stream = AudioStreamMP3.new()
	stream.data = buffer
	emit_signal("stream_ready", stream)

func clear_queue():
	playlist.clear()
	playing_music = false
	emit_signal("stop_stream")
