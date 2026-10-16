class_name IngredientButton
extends TextureButton

var ingredient_data: IngredientData

const PLACEHOLDER = preload("uid://dmgyikgjpk43o")

func _ready():
	pass

func setup(ingredient: IngredientData):
	ingredient_data = ingredient
	if ingredient and ingredient.texture:
		texture_normal = ingredient.texture
