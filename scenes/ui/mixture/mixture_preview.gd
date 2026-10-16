class_name MixturePreview
extends PanelContainer

signal add_ingredient_pressed
signal undo_button_pressed
signal reset_button_pressed

@onready var mixture_visuals: MixtureVisuals = %MixtureVisuals
@onready var mixture_texture: TextureRect = %MixtureTexture
@onready var fluid_texture: TextureRect = %FluidTexture
@onready var mixture_counter_label: Label = %MixtureCounterLabel

@onready var add_ingredient_button: Button = %AddIngredientButton
@onready var undo_button: Button = %UndoButton
@onready var reset_mixture_button: Button = %ResetMixtureButton

@onready var bubble_particles: GPUParticles2D = %BubbleParticles
@onready var fire_particles: GPUParticles2D = %FireParticles
@onready var water_particles: GPUParticles2D = %WaterParticles
@onready var air_particles: GPUParticles2D = %AirParticles
@onready var earth_particles: GPUParticles2D = %EarthParticles

@onready var mixture_contents: GridContainer = %MixtureContents

var mixture_animation: Tween

const MIXTURE_0_2 = preload("uid://bl71y45w4v2ve")
const MIXTURE_1_2 = preload("uid://bx38wha5yyd6e")
const MIXTURE_2_2 = preload("uid://cjm85d6o6m6y0")

const MIXTURE_0_3 = preload("uid://cd1dnp7qfvo3w")
const MIXTURE_1_3 = preload("uid://c5xf04unq2435")
const MIXTURE_2_3 = preload("uid://ctml3bd20wklk")
const MIXTURE_3_3 = preload("uid://dy4tmy4hmh8os")

const MIXTURE_0_4 = preload("uid://sf8xocwbad31")
const MIXTURE_1_4 = preload("uid://bggtwy4ogvghv")
const MIXTURE_2_4 = preload("uid://60ogeb0olk5y")
const MIXTURE_3_4 = preload("uid://c14ja58t8u5cv")
const MIXTURE_4_4 = preload("uid://cqj5eu4yhwtip")

const INGREDIENT_BUTTON = preload("uid://l3820xqp3mn7")


var mixture_textures = {
	2: {
		0: MIXTURE_0_2,
		1: MIXTURE_1_2,
		2: MIXTURE_2_2 
	},
	3: {
		0: MIXTURE_0_3,
		1: MIXTURE_1_3,
		2: MIXTURE_2_3,
		3: MIXTURE_3_3
	},
	4: {
		0: MIXTURE_0_4,
		1: MIXTURE_1_4,
		2: MIXTURE_2_4,
		3: MIXTURE_3_4,
		4: MIXTURE_4_4
	}
}

func _ready():
	add_ingredient_button.pressed.connect(
		func():
			add_ingredient_pressed.emit()
	)
	
	undo_button.pressed.connect(
		func():
			undo_button_pressed.emit()
	)
	
	reset_mixture_button.pressed.connect(
		func():
			reset_button_pressed.emit()
	)


func update(mixture: Mixture):
	update_contents(mixture)
	update_texture(mixture)
	mixture_visuals.set_mixture_energy(mixture.get_mixture_energy())

func update_contents(mixture: Mixture):
	pass
	for child in mixture_contents.get_children():
		child.queue_free()
	
	for i in range(mixture.max_ingredients):
		var entry: IngredientButton = INGREDIENT_BUTTON.instantiate()
		if i < mixture.ingredients.size():
			var mixture_entry := mixture.ingredients[i]
			if mixture_entry.ingredient:
				entry.setup(mixture_entry.ingredient)
		else:
			entry.setup(null)
		
		mixture_contents.add_child(entry)

func update_texture(mixture: Mixture):
	var max_ingredients = mixture.max_ingredients
	var current_ingredients = mixture.ingredients.size()
	
	mixture_texture.texture = mixture_textures[max_ingredients][0]
	if current_ingredients == 0:
		fluid_texture.texture = null
	else:
		fluid_texture.texture = mixture_textures[max_ingredients][current_ingredients]
		
	mixture_counter_label.text = "%s/%s" % [current_ingredients, max_ingredients]
	
	if mixture_animation:
			mixture_animation.kill()
	
	var balance := mixture.get_balance()
	mixture_animation = create_tween().set_loops()
	#mixture_animation.tween_property(
		#fluid_texture, "modulate", Color("00000050"), 0.2
	#)
	var tween_color: Color
	if balance.x == 0:
		tween_color = Color("#42244a")
	elif balance.x > 0:
		tween_color = Color("#1699f0")
	else:
		tween_color = Color("#ff7f50")
	mixture_animation.tween_property(
		fluid_texture, "modulate", tween_color, 0.5
	)
	if balance.y == 0:
		tween_color = Color("#42244a")
	elif balance.y > 0:
		tween_color = Color("#bb8000")
	else:
		tween_color = Color("#8c9632")
	mixture_animation.tween_property(
		fluid_texture, "modulate", tween_color, 0.5
	)
	
	update_particles(mixture)
	


func update_particles(mixture: Mixture):
	var energy = mixture.get_mixture_energy()
	setup_particles(water_particles, energy.water)
	setup_particles(fire_particles, energy.fire)
	setup_particles(air_particles, energy.air)
	setup_particles(earth_particles, energy.earth)
	
	if mixture.is_empty():
		bubble_particles.hide()
	else:
		bubble_particles.show()

func setup_particles(particles: GPUParticles2D, energy:float):
	var max_energy = 6.0
	particles.show()
	particles.amount_ratio = energy/max_energy


func enable_reset_button():
	reset_mixture_button.disabled = false


func disable_reset_button():
	reset_mixture_button.disabled = true


func enable_add_button():
	add_ingredient_button.disabled = false


func disable_add_button():
	add_ingredient_button.disabled = true


func disable_undo_button():
	undo_button.disabled = true


func enable_undo_button():
	undo_button.disabled = false
