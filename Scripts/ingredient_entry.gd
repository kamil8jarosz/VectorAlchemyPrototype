class_name IngredientEntry
extends Button


var ingredient: IngredientData

func setup(data: IngredientData):
	ingredient = data
	text = data.ingredient_name
	
