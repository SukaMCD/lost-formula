extends Control  # Lebih baik menggunakan CanvasLayer daripada Control

@onready var resume_button = $ResumeButton  # Asumsi ada node Button bernama ResumeButton
@onready var exit_button = $ExitButton      # Asumsi ada node Button bernama ExitButton

var is_paused: bool = false:
	set(value):
		is_paused = value
		get_tree().paused = is_paused
		visible = is_paused

func _ready():
	hide()  # Sembunyikan saat awal
	process_mode = Node.PROCESS_MODE_ALWAYS  # Penting agar tetap aktif saat game paused
	
	# Hubungkan signal button
func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("accept"):  # Gunakan action "pause" bukan "accept"
		self.is_paused = !is_paused
		get_viewport().set_input_as_handled()  # Mencegah input menyebar

func _on_exit_button_pressed():
	get_tree().quit()

func _on_resume_button_pressed():
	self.is_paused = false
