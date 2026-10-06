extends Control
class_name NumberLine

@export var maximum_value: float = 21.0

@onready var fire_label: Label = $FireLabel
@onready var water_label: Label = $WaterLabel
@onready var balance_label: Label = $BalanceLabel

var current_position: float = 0.0
var preview_position: float = 0.0
var current_position_height: float = 0.0
var movement_tween: Tween


var discoveries: Array[Discovery] = []


const FIRE_COLOR := Color.CORAL
const WATER_COLOR := Color.DEEP_SKY_BLUE
const BALANCE_COLOR := Color.WHITE

var y := size.y / 2.0
var left := 20.0
var right := size.x - left


func _ready():
	queue_redraw()
	position_labels()


func clear():
	current_position = 0.0
	preview_position = 0.0
	queue_redraw()

func set_preview_position(new_position):
	preview_position = new_position
	queue_redraw()


func set_current_position(new_position):
	if movement_tween:
		movement_tween.kill()
	
	movement_tween = create_tween()
	movement_tween.set_trans(Tween.TRANS_QUAD)
	movement_tween.set_ease(Tween.EASE_OUT)
	movement_tween.tween_method(
		_set_current_position,
		current_position,
		new_position,
		0.25
	)


func _set_current_position(new_position: float):
	current_position = new_position
	queue_redraw()


func set_discoveries(_discoveries: Array[Discovery]):
	discoveries = _discoveries
	queue_redraw()


func _draw():
	draw_discovery_zones()
	draw_axis()
	draw_current_position()
	draw_preview_position()
	


func draw_axis():
	var segments := 64
	
	for i in range(segments):
		var t1 := float(i) / segments
		var t2 := float(i+1) / segments
		
		var x1 = lerp(left, right, t1)
		var x2 = lerp(left, right, t2)
		
		var color := get_gradient_color(t1)
		
		draw_line(
			Vector2(x1, y),
			Vector2(x2, y),
			color,
			3.0
		)
		
	draw_arrow_tip(Vector2(left, y), -1.0, FIRE_COLOR)
	draw_arrow_tip(Vector2(right, y), 1.0, WATER_COLOR)
	
	draw_ticks()
	draw_zero_marker()


func draw_arrow_tip(arrow_pos: Vector2, direction: float, color: Color):
	var arrow_size := 6.0
	
	var tip := arrow_pos + Vector2(direction*arrow_size, 0)
	var top := arrow_pos + Vector2(0, -arrow_size)
	var bottom := arrow_pos + Vector2(0, arrow_size)
	
	draw_colored_polygon(
		PackedVector2Array([tip, top, bottom]),
		color
	)


func draw_ticks():
	# Additional tick for the origin
	var ticks = 2 * maximum_value + 1
	var ticks_size = 5
	
	for i in range(ticks):
		var x = lerp(left, right, i/(ticks-1))
		draw_line(
			Vector2(x, y-ticks_size),
			Vector2(x, y+ticks_size),
			get_gradient_color(i/(ticks-1)),
			1.0
		)


func draw_zero_marker():
	var marker_size := 10
	var x:= value_to_x(0.0)
	
	draw_line(
		Vector2(x, y-marker_size),
		Vector2(x, y+marker_size),
		BALANCE_COLOR,
		2.0
	)

func draw_discovery_zones():
	for discovery in discoveries:
		var x1 := value_to_x(discovery.min_position)
		var x2 := value_to_x(discovery.max_position)
		
		var rect:= Rect2(
			x1,
			y - 6,
			x2-x1,
			12
		)
		
		draw_rect(rect, Color(1.0,0.0,1.0,0.25))
		
		draw_line(
			Vector2(x1, y-4),
			Vector2(x1, y+4),
			Color(1.0,1.0,1.0,0.35),
			1.0
		)
		
		draw_line(
			Vector2(x2, y-4),
			Vector2(x2, y+4),
			Color(1.0,1.0,1.0,0.35),
			1.0
		)


func draw_current_position():
	var x = value_to_x(current_position)
	
	draw_circle(
		Vector2(x,y+current_position_height),
		5.0,
		Color.BLACK
	)
	
	draw_circle(
		Vector2(x,y+current_position_height),
		4.0,
		get_gradient_color(x/(right-left))
	)


func draw_preview_position():
	var x = value_to_x(preview_position)
	
	draw_circle(
		Vector2(x,y),
		3.0,
		Color.DIM_GRAY
	)


func position_labels():
	var y_offset := 10.0
	
	fire_label.position.x = left - fire_label.size.x/2.0
	fire_label.position.y = y + y_offset
	
	balance_label.position.x = value_to_x(0.0) - balance_label.size.x/2.0
	balance_label.position.y = y + y_offset
	
	water_label.position.x = right - water_label.size.x/2.0
	water_label.position.y = y + y_offset


func value_to_x(value: float) -> float:
	return remap(
		value,
		-maximum_value,
		maximum_value,
		left,
		right
	)


func get_gradient_color(t: float) -> Color:
	if t < 0.5:
		return FIRE_COLOR.lerp(BALANCE_COLOR, t * 2.0)
	else:
		return BALANCE_COLOR.lerp(WATER_COLOR, (t-0.5) * 2.0)
