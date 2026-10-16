class_name MapNode
extends Control


var maximum_value_x: float = 7.0
var maximum_value_y: float = 7.0

@onready var fire_label: Label = %FireLabel
@onready var water_label: Label = %WaterLabel
@onready var balance_label: Label = %BalanceLabel
@onready var air_label: Label = %AirLabel
@onready var earth_label: Label = %EarthLabel

@onready var position_label: Label = %PositionLabel
@onready var preview_label: Label = %PreviewLabel


var animation_tween: Tween
var marker_color := Color("#FFFFFF")
var current_position := Vector2(0.0, 0.0)
var preview_position := Vector2(0.0, 0.0)
var draw_preview: bool = false
var draw_y: bool = false

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
	mid_x = size.x / 2.0
	mid_y = size.y / 2.0
	left = 20.0
	right = size.x - left
	top = 20.0
	bottom = size.y - top
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
	if new_position.y != 0:
		draw_y = true
		
	while (
		current_position.x >= maximum_value_x
		or current_position.y >= maximum_value_y 
	):
		maximum_value_x += 1
		maximum_value_y += 1
	
	_update_position_label()
	queue_redraw()


func add_discovery(discovery: Discovery):
	discoveries.append(discovery)
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


func _update_position_label():
	if draw_y:
		position_label.text = "(%d, %d)" % [current_position.x, -current_position.y]
	else:
		position_label.text = "%d" % current_position.x
		
	if draw_preview:
		if draw_y:
			preview_label.text = "(%d, %d)" % [preview_position.x, -preview_position.y]
		else:
			preview_label.text = "%d" % preview_position.x
		

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
	animation_tween.set_ease(Tween.EASE_IN)
	
	return animation_tween


func play_discovery_animation():
	var blink_color := Color("0c343e")
	animation_tween = create_setup_tween().set_parallel(false)
	
	animation_tween.tween_method(
		set_marker_color,
		Color("FFFFFF"),
		blink_color,
		0.4
	)
	animation_tween.tween_method(
		set_marker_color,
		blink_color,
		Color("FFFFFF"),
		0.3
	)
	animation_tween.tween_method(
		set_marker_color,
		Color("FFFFFF"),
		blink_color,
		0.2
	)
	animation_tween.tween_method(
		set_marker_color,
		blink_color,
		Color("FFFFFF"),
		0.1
	)
	animation_tween.tween_method(
		set_marker_color,
		Color("FFFFFF"),
		blink_color,
		0.1
	)
	animation_tween.tween_method(
		set_marker_color,
		blink_color,
		Color("FFFFFF"),
		0.1
	)
	animation_tween.tween_method(
		set_marker_color,
		Color("FFFFFF"),
		blink_color,
		0.1
	)
	animation_tween.tween_method(
		set_marker_color,
		blink_color,
		Color("FFFFFF"),
		0.1
	)



func _draw():
	draw_discovery_zones()
	draw_axes()
	position_labels()
	draw_current_position()
	draw_preview_position()


func draw_axes():
	draw_water_axis()
	draw_fire_axis()
	
	if draw_y:
		draw_air_axis()
		draw_earth_axis()
		draw_grid_points()
		air_label.show()
		earth_label.show()
		balance_label.hide()
	else:
		air_label.hide()
		earth_label.hide()


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
	var ticks_size = 3
	
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
			if i == 0 or j == 0:
				continue
			
			var p = Vector2(
				value_to_x(i),
				value_to_y(j)
			)
			
			draw_circle(
				p,
				0.5,
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
		
		draw_rect(rect, Color(1.0,0.0,1.0,1.0))


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
	
	fire_label.position = Vector2(
		left - fire_label.size.x/2.0,
		mid_y + y_offset
	)
	
	balance_label.position = Vector2(
		mid_x - balance_label.size.x/2.0,
		mid_y + y_offset
	)
	
	water_label.position = Vector2(
		right - water_label.size.x,
		mid_y + y_offset
	)
	
	air_label.position = Vector2(
		mid_x, 
		top
	)
	
	earth_label.position = Vector2(
		mid_x,
		bottom - earth_label.size.y
	)


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


func value_to_vector(value: Vector2) -> Vector2:
	return Vector2(
		value_to_x(value.x),
		value_to_y(value.y)
	)
	

func get_gradient_color(t: float) -> Color:
	if t < 0.5:
		return FIRE_COLOR.lerp(BALANCE_COLOR, t * 2.0)
	else:
		return BALANCE_COLOR.lerp(WATER_COLOR, (t-0.5) * 2.0)
