extends Control
class_name AlchemyLine

var maximum_value_x: float = 11.0
var maximum_value_y: float = 6.0

@onready var fire_label: Label = %FireLabel
@onready var water_label: Label = %WaterLabel
@onready var balance_label: Label = %BalanceLabel

var animation_tween: Tween
var marker_color := Color("#FFFFFF")
var current_position := Vector2(0.0, 0.0)
var preview_position := Vector2(0.0, 0.0)
var draw_preview: bool = false

var discoveries: Array[Discovery] = []

const BALANCE_COLOR := Color("#FFFFFF")
const FIRE_COLOR := Color("#FF7F50")
const WATER_COLOR := Color("#00BFFF")
const AIR_COLOR := Color("#8C9632")
const EARTH_COLOR := Color("#BB8000")

var mid_x := size.x / 2.0
var mid_y := size.y / 2.0
var left := 20.0
var right := size.x - left
var top := 20.0
var bottom := size.y - top


func _ready():
	queue_redraw()
	position_labels()


func set_draw_preview(value: bool):
	draw_preview = value

func set_marker_color(value: Color):
	marker_color = value
	queue_redraw()

func set_preview_position(new_position: Vector2):
	preview_position = new_position
	queue_redraw()


func _set_current_position(new_position: Vector2):
	current_position = new_position
	queue_redraw()


func set_discoveries(_discoveries: Array[Discovery]):
	discoveries = _discoveries
	queue_redraw()


func set_current_position(new_position):
	create_setup_tween().set_parallel(true)
	animation_tween.set_ease(Tween.EASE_IN)
	animation_tween.tween_method(
		_set_current_position,
		current_position,
		(current_position+new_position)/2,
		0.12
	)
	animation_tween.tween_method(
		_set_current_position,
		(current_position+new_position)/2,
		new_position,
		0.12
	)
	


func clear():
	current_position = Vector2(0.0, 0.0)
	preview_position = Vector2(0.0, 0.0)
	marker_color = Color("#FFFFFF")
	queue_redraw()


func create_setup_tween() -> Tween:
	if animation_tween:
		animation_tween.kill()
		
	animation_tween = create_tween()
	animation_tween.set_trans(Tween.TRANS_QUAD)
	animation_tween.set_ease(Tween.EASE_IN_OUT)
	
	return animation_tween


func play_discovery_animation():
	animation_tween = create_setup_tween().set_parallel(false)
	animation_tween.tween_method(
		set_marker_color,
		Color("FFFFFF"),
		Color("#5e3370"),
		0.2
	)
	animation_tween.tween_method(
		set_marker_color,
		Color("#5e3370"),
		Color("FFFFFF"),
		0.2
	)
	animation_tween.tween_method(
		set_marker_color,
		Color("FFFFFF"),
		Color("#5e3370"),
		0.3
	)
	animation_tween.tween_method(
		set_marker_color,
		Color("#5e3370"),
		Color("FFFFFF"),
		0.3
	)



func _draw():
	draw_discovery_zones()
	draw_axes()
	draw_current_position()
	draw_preview_position()


func draw_axes():
	draw_water_axis()
	draw_fire_axis()
	#draw_air_axis()
	#draw_earth_axis()
	#draw_grid_points()


func draw_water_axis():
	var start = Vector2(mid_x, mid_y)
	var end = Vector2(right, mid_y)
	
	draw_axis(start, end, BALANCE_COLOR, WATER_COLOR)
	draw_arrow_tip(end, Vector2(1,0), WATER_COLOR)
	draw_ticks(start, end, maximum_value_x, Vector2(0,1), BALANCE_COLOR, WATER_COLOR)


func draw_fire_axis():
	var start = Vector2(left, mid_y)
	var end = Vector2(mid_x, mid_y)
	
	draw_axis(start, end, FIRE_COLOR, BALANCE_COLOR)
	draw_arrow_tip(start, Vector2(-1,0), FIRE_COLOR)
	draw_ticks(start, end, maximum_value_x, Vector2(0,1), FIRE_COLOR, BALANCE_COLOR)


func draw_air_axis():
	var start = Vector2(mid_x, mid_y)
	var end = Vector2(mid_x, top)
	
	draw_axis(start, end, BALANCE_COLOR, AIR_COLOR)
	draw_arrow_tip(end, Vector2(0,-1), AIR_COLOR)
	draw_ticks(start, end, maximum_value_y, Vector2(1,0), BALANCE_COLOR, AIR_COLOR)


func draw_earth_axis():
	var start = Vector2(mid_x, mid_y)
	var end = Vector2(mid_x, bottom)
	
	draw_axis(start, end, BALANCE_COLOR, EARTH_COLOR)
	draw_arrow_tip(end, Vector2(0,1), EARTH_COLOR)
	draw_ticks(start, end, maximum_value_y, Vector2(1,0), BALANCE_COLOR, EARTH_COLOR)


func draw_axis(start: Vector2, end:Vector2, start_color:Color, end_color:Color):
	var segments := 64
	
	for i in range(segments):
		var t1 := float(i) / segments
		var t2 := float(i+1) / segments
		
		var p1 := start.lerp(end, t1)
		var p2 := start.lerp(end, t2)
		
		var color := start_color.lerp(end_color, t1)
		
		draw_line(
			p1,
			p2,
			color,
			3.0
		)


func draw_arrow_tip(pos: Vector2, direction: Vector2, color: Color):
	var dir := direction.normalized()
	var head_length := 12.0
	var head_width := 12.0
	
	var tip := pos + dir * head_length
	var perpendicular := Vector2(-dir.y, dir.x) * head_width / 2.0
	
	draw_colored_polygon(
		PackedVector2Array([
			tip,
			pos + perpendicular,
			pos - perpendicular
		]),
		color
	)


func draw_ticks(
	start: Vector2, 
	end: Vector2, 
	maximum_value: float, 
	direction: Vector2,
	start_color: Color,
	end_color: Color
):
	var ticks = int(maximum_value)
	var ticks_size = 5
	
	for i in range(ticks):
		var t := i/float(ticks)
		var p := start.lerp(end, t)
		draw_line(
			p + direction * ticks_size,
			p - direction * ticks_size,
			start_color.lerp(end_color, t),
			1.0
		)


func draw_grid_points():
	for i in range(-maximum_value_x, maximum_value_x+1):
		for j in range(-maximum_value_y, maximum_value_y+1):
			var p = Vector2(
				value_to_x(i),
				value_to_y(j)
			)
			draw_circle(
				p,
				1.0,
				Color("#FFFFFF")
			)
			
			

func draw_zero_marker():
	var marker_size := 10
	var x:= value_to_x(0.0)
	
	draw_line(
		Vector2(x, mid_y - marker_size),
		Vector2(x, mid_y + marker_size),
		BALANCE_COLOR,
		2.0
	)


func draw_discovery_zones():
	for discovery in discoveries:
		var x1 := value_to_x(discovery.min_position_x)
		var x2 := value_to_x(discovery.max_position_x)
		var y1 := value_to_y(discovery.min_position_y)
		var y2 := value_to_y(discovery.max_position_y)
		
		var rect:= Rect2(
			x1,
			y1,
			x2-x1,
			y2-y1
		)
		
		draw_rect(rect, Color(1.0,0.0,1.0,0.5))


func draw_current_position():
	var x = value_to_x(current_position.x)
	var y = value_to_y(current_position.y)
	
	draw_circle(
		Vector2(x,y),
		6.0,
		Color("#000000")
	)
	
	draw_circle(
		Vector2(x,y),
		5.0,
		marker_color
	)


func draw_preview_position():
	if not draw_preview:
		return
	
	var x = value_to_x(preview_position.x)
	var y = value_to_y(preview_position.y)
	
	draw_circle(
		Vector2(x,y),
		6.0,
		Color("00000080"),
		false,
		2.0
	)
	
	draw_circle(
		Vector2(x,y),
		4.0,
		Color("FFFFFF80"),
	)


func position_labels():
	var y_offset := 10.0
	
	fire_label.position.x = left - fire_label.size.x/2.0
	fire_label.position.y = mid_y + y_offset
	
	balance_label.position.x = value_to_x(0.0) - balance_label.size.x/2.0
	balance_label.position.y = mid_y + y_offset
	
	water_label.position.x = right - water_label.size.x/2.0
	water_label.position.y = mid_y + y_offset


func value_to_x(value: float) -> float:
	return remap(
		value,
		-maximum_value_x,
		maximum_value_x,
		left,
		right
	)

func value_to_y(value: float) -> float:
	return remap(
		value,
		-maximum_value_y,
		maximum_value_y,
		top, 
		bottom
	)


func get_gradient_color(t: float) -> Color:
	if t < 0.5:
		return FIRE_COLOR.lerp(BALANCE_COLOR, t * 2.0)
	else:
		return BALANCE_COLOR.lerp(WATER_COLOR, (t-0.5) * 2.0)
