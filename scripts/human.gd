extends Node3D

func _ready():
	# Obtener todos los hijos de humano 
	var humanos = get_children()
	
	for human in humanos:
		if human.has_node("AnimationPlayer"):  # Verificar si tiene AnimationPlayer
			var animation_player = human.get_node("AnimationPlayer")
			animation_player.play("Take 001")  # Cambia "default" al nombre de tu animación
		else:
			print("No se encontró AnimationPlayer en: ", human.name)
