extends Node3D

@onready var pantalla_carga = $PantallaCarga
@onready var barra_progreso = $PantallaCarga/ProgressBar
@onready var boton_iniciar = $PantallaCarga/ButtonIniciar
@onready var boton_ir_otra_pantalla = $PantallaCarga/ButtonIrOtraPantalla
@onready var boton_finalizar = $PantallaCarga/ButtonFinalizar
@onready var label = $PantallaCarga/Label
@onready var otra_pantalla = $OtraPantalla
@onready var label_otra_pantalla = $OtraPantalla/Label
@onready var boton_regresar = $OtraPantalla/ButtonRegresar
@onready var personaje = $CharacterBody3D

var juego_iniciado = false  # Variable que indica si el juego ha comenzado

func _ready():
	inicializar_pantalla_carga()
	mostrar_pantalla_carga()
	await esperar_frame()
	await cargar_escenario()
	habilitar_boton_iniciar()

func inicializar_pantalla_carga():
	# Configuración inicial de la pantalla de carga
	pantalla_carga.visible = false  # Comienza oculta
	barra_progreso.min_value = 0
	barra_progreso.max_value = 5
	barra_progreso.value = 0
	boton_iniciar.visible = false
	label.visible = true  # El label debe ser visible al inicio

func mostrar_pantalla_carga():
	pantalla_carga.visible = true  # Muestra la pantalla de carga
	otra_pantalla.visible = false  # Oculta la otra pantalla
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)  # Hace visible el mouse
	personaje.set_process(false)  # Detiene el procesamiento del personaje
	set_process_input(true)  # Activa el manejo de eventos de entrada
	personaje.desactivar_movimiento()  # Desactiva el movimiento del personaje y cámara
	juego_iniciado = false  # Resetea el estado del juego

	# Asegúrate de que el botón de inicio esté visible solo después de que la carga termine
	if not boton_iniciar.visible:
		boton_iniciar.visible = false  # Se asegura de que esté oculto al inicio
		barra_progreso.visible = true  # Muestra la barra de progreso durante la carga
		label.visible = true  # Muestra el label de carga
		if juego_iniciado:
			habilitar_boton_iniciar()

func habilitar_boton_iniciar():
	# Habilita el botón para que el jugador pueda iniciar el juego
	barra_progreso.visible = false  # Oculta la barra de progreso
	boton_iniciar.visible = true
	label.visible = false  # Oculta el label al finalizar la carga

func ocultar_pantalla_carga():
	pantalla_carga.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  # Captura el mouse
	personaje.set_process(true)  # Reactiva el procesamiento del personaje
	set_process_input(true)  # Reactiva el manejo de eventos de entrada
	personaje.activar_movimiento()  # Reactiva el movimiento del personaje y cámara
	juego_iniciado = true  # El juego ha comenzado

func esperar_frame():
	# Usamos un temporizador para permitir el renderizado de un frame
	await get_tree().create_timer(0.01).timeout

func cargar_escenario():
	# Simula la carga del escenario en 5 pasos
	for i in range(5):
		barra_progreso.value = i + 1
		print("Cargando parte ", i + 1)
		await get_tree().create_timer(0.5).timeout  # Simula un retraso por carga

func _input(event):
	# Depuración para asegurarse de que el input se recibe
	print("Evento de entrada recibido")

	# Detectar la tecla Enter o el botón Start del mando para mostrar la pantalla de carga
	if Input.is_action_pressed("toggle_loading_screen") and not pantalla_carga.visible and juego_iniciado:
		print("Tecla Enter presionada o acción de mando detectada")
		mostrar_pantalla_carga()  # Muestra la pantalla de carga

	# Detectar el botón Start del mando
	if event is InputEventJoypadButton:
		if event.button_index == JOY_BUTTON_START:
			print("Botón Start presionado")
			if not pantalla_carga.visible and juego_iniciado:
				mostrar_pantalla_carga()  # Muestra la pantalla de carga

	# Ignorar eventos del mouse durante la pantalla de carga
	if pantalla_carga.visible:
		if event is InputEventMouseMotion or event is InputEventMouseButton:
			return  # No hacer nada con estos eventos

func _on_button_iniciar_pressed() -> void:
	# Lógica para iniciar el juego
	print("¡Juego iniciado!")
	ocultar_pantalla_carga()

func _on_button_ir_otra_pantalla_pressed() -> void:
	# Lógica para cambiar a otra pantalla
	pantalla_carga.visible = false  # Oculta la pantalla de carga
	otra_pantalla.visible = true  # Muestra la otra pantalla
	print("Cambiando a otra pantalla...")

func _on_button_regresar_pressed() -> void:
	# Lógica para regresar a la pantalla de carga
	otra_pantalla.visible = false  # Oculta la otra pantalla
	pantalla_carga.visible = true  # Muestra la pantalla de carga
	print("Regresando a la pantalla de carga.")

func _on_button_finalizar_pressed() -> void:
	# Lógica para finalizar el juego
	print("Juego finalizado.")
	get_tree().quit()  # Cierra el juego
