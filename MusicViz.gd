extends Spatial

const MIN_DB = 80
const PER_ORDER_COUNT = 40
const ORDERS = 4

var spectrum: AudioEffectSpectrumAnalyzerInstance
var count: int

func _init():
	spectrum = AudioServer.get_bus_effect_instance(0, 0)

func _ready():
	count = ORDERS * PER_ORDER_COUNT
	for i in count:
		var bar: Spatial = preload("res://FreqBar/FreqBar.tscn").instance()
		bar.translation.x = -24.0 + ((i)/3.0)
		bar.COLOR = Color.from_hsv(0.4 + float(i) / (4.0 * count), 1, 1)
		$FreqBars.add_child(bar)

func _process(delta):
	if $AudioStreamPlayer.playing:
		var prev_hz = 0
		var increment
		var i = 0

		for order in ORDERS:
			increment = pow(10, order)
			for bucket in PER_ORDER_COUNT:
				var hz = prev_hz + ((float(bucket) / PER_ORDER_COUNT) * increment)
				var f = spectrum.get_magnitude_for_frequency_range(prev_hz, hz, AudioEffectSpectrumAnalyzerInstance.MAGNITUDE_MAX)
				
				var energy = clamp(
					(MIN_DB + linear2db(f.length())) / MIN_DB,
					0, 1
				)
				var bar = $FreqBars.get_child(i)
				bar.translation.y = lerp(bar.translation.y, energy * 8, 1 - pow(0.001, delta))
				prev_hz = hz
				i += 1

func _on_HUD_stream_ready(stream: AudioStream):
	$AudioStreamPlayer.stream = stream
	$AudioStreamPlayer.play(0)
