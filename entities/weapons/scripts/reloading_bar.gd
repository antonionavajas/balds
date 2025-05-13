extends ProgressBar

@export var timer : Timer
@export var run_timer : bool = true

func _process(delta: float) -> void:
	if run_timer:
		var calculated_value =  timer.time_left * 100 /timer.wait_time
		value = calculated_value
	else: 
		value = 0
