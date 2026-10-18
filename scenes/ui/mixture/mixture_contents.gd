class_name MixtureContents
extends GridContainer

const INGREDIENT_BUTTON = preload("uid://l3820xqp3mn7")


func update_contents(mixture: Mixture):
	pass
	for child in get_children():
		child.queue_free()
	
	for i in range(mixture.max_ingredients):
		var entry: IngredientButton = INGREDIENT_BUTTON.instantiate()
		if i < mixture.ingredients.size():
			var mixture_entry := mixture.ingredients[i]
			if mixture_entry.ingredient:
				entry.setup(mixture_entry.ingredient)
		else:
			entry.setup(null)
		
		add_child(entry)
