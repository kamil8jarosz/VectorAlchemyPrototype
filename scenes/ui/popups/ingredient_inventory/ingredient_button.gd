class_name IngredientButton
extends TextureButton

var ingredient_data: IngredientData

const PLACEHOLDER = preload("uid://dmgyikgjpk43o")

func _ready():
	pass

func setup(data: IngredientData):	
	ingredient_data = data
	if data and data.texture:
		texture_normal = data.texture
