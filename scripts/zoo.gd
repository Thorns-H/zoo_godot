extends Node3D

func _ready():
	# Obtener todos los hijos de Zoo (los animales)
	var animales = get_children()
	
	for animal in animales:
		if animal.has_node("AnimationPlayer"):  # Verificar si tiene AnimationPlayer
			var animation_player = animal.get_node("AnimationPlayer")
			animation_player.play("mixamo_com")  # Cambia "default" al nombre de tu animación
		else:
			print("No se encontró AnimationPlayer en: ", animal.name)
