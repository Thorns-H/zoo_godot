extends CharacterBody3D

var velocidad: float = 15.0
var gravedad: float = -9.8
var direccion: Vector3 = Vector3()

# Sensibilidad del ratón y joystick
var sensibilidad_mouse: float = 0.2
var sensibilidad_joystick: float = 1.0  # Sensibilidad para el joystick derecho
var rotacion_vertical: float = 0.0  # Control de la rotación vertical (evita giros extremos)

# Referencia a la cámara
@onready var camara: Camera3D = $Camera3D
var puede_moverse: bool = true  # Controla si el personaje puede moverse o no

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  # Captura el puntero del ratón al iniciar

func _process(delta: float) -> void:
	if not puede_moverse:
		return  # Si no puede moverse, no procesamos nada

	# Controles de dirección del personaje (teclado o joystick izquierdo)
	var input_direccion = Vector3(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		0,
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)

	if input_direccion.length() > 0:
		# Convertir la dirección de entrada al espacio global según la rotación de la cámara
		direccion = (camara.global_transform.basis * input_direccion).normalized()
	else:
		direccion = Vector3.ZERO

	# Movimiento horizontal del personaje
	velocity.x = direccion.x * velocidad
	velocity.z = direccion.z * velocidad

	# Aplicar gravedad y verificar colisión con el suelo
	if not is_on_floor():
		velocity.y += gravedad * delta
	else:
		velocity.y = 0  # Resetear la velocidad vertical si está en el suelo

	# Mover el personaje
	move_and_slide()

	# Control de la cámara con el joystick derecho (ejes 2 y 3) - Solo si el personaje puede moverse
	if puede_moverse:
		var joystick_camera_x = Input.get_joy_axis(0, 2)  # Eje X del joystick derecho
		var joystick_camera_y = Input.get_joy_axis(0, 3)  # Eje Y del joystick derecho

		# Rotación horizontal de la cámara
		rotate_y(deg_to_rad(-joystick_camera_x * sensibilidad_joystick))  # Rotación horizontal con joystick

		# Mover la cámara vertical (rotación alrededor del eje X), limitada para evitar giros extremos
		rotacion_vertical -= joystick_camera_y * sensibilidad_joystick
		rotacion_vertical = clamp(rotacion_vertical, -80.0, 80.0)  # Limitar entre -80 y 80 grados
		camara.rotation_degrees.x = rotacion_vertical

func _input(event: InputEvent) -> void:
	if not puede_moverse:
		return  # Si no se puede mover, no procesamos eventos

	if event is InputEventMouseMotion:
		# Rotación horizontal del cuerpo con el mouse
		rotate_y(deg_to_rad(-event.relative.x * sensibilidad_mouse))

		# Rotación vertical de la cámara con el mouse (limitada)
		rotacion_vertical -= event.relative.y * sensibilidad_mouse
		rotacion_vertical = clamp(rotacion_vertical, -80.0, 80.0)  # Limitar entre -80 y 80 grados
		camara.rotation_degrees.x = rotacion_vertical

# Métodos para controlar el estado del movimiento
func desactivar_movimiento():
	puede_moverse = false  # Desactiva el movimiento y control de la cámara

func activar_movimiento():
	puede_moverse = true  # Reactiva el movimiento y control de la cámara
