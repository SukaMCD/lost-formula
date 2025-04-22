extends Control

# Variabel ekspor untuk kontrol animasi
@export var tween_intensity: float = 1.2 # Seberapa besar perubahan skala saat dihover
@export var tween_duration: float = 0.3 # Durasi animasi tween dalam detik

# Variabel onready untuk merujuk ke node Button
@onready var play: Button = $Play
@onready var exit: Button = $Exit

# Fungsi _process() dipanggil setiap frame
func _process(_delta: float) -> void:
	if play and exit:  # Pastikan tombol play dan exit ada
		btn_hovered(play)
		btn_hovered(exit)

# Fungsi untuk membuat animasi tween
func start_tween(object: Object, property: String, final_val: Variant, duration: float):
	var tween = create_tween()
	tween.tween_property(object, property, final_val, duration)
	tween.start()

# Fungsi untuk mengelola hover pada tombol
func btn_hovered(button: Button):
	if button:
		# Mengatur pivot point agar animasi lebih terpusat
		button.rect_pivot_offset = button.rect_size / 2
	
		if button.is_hovered():
			# Jika dihover, mulai animasi untuk meningkatkan skala
			start_tween(button, "scale", Vector2.ONE * (1 + tween_intensity), tween_duration)
		else:
			# Jika tidak dihover, kembalikan skala ke normal
			start_tween(button, "scale", Vector2.ONE, tween_duration)


func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Worlds/forest.tscn")
