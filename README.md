# Lost Formula - Contributor README

### Project Info
- **Engine**: Godot 4.1+
- **Tipe Game**: 2D Top-Down Adventure
- **Style**: Pixel Art (character), Vector UI (UI/UX)

---

### Clone Repository
```
git clone https://github.com/SukaMCD/lost-formula.git
```

---

### Struktur Project (Folder Penting)
```
/scenes          -> Semua scene utama (player, map, ui)
/scripts         -> Script GDScript
/assets          -> Sprite, tileset, UI, dll
```

---

### Fitur Utama (yang udah ada)
- Player Movement 8 arah (`player.gd`)
- Animasi Idle, Run (AnimatedSprite2D)
- Camera Follow (Camera2D)

---

### Konvensi Coding
- Gunakan **snake_case** untuk variabel dan fungsi
- Nama animasi: `idle`, `run_right`, `run_left`, `run_up`, `run_down`
- Prefix nama scene: `player_`, `enemy_`, `npc_`, `ui_`

---

### Cara Run Lokal
1. Buka project di Godot 4.x
2. Scene utama: `scenes/world.tscn`
3. Mainkan (F5)

---

### Todo (Next Progress)

**Naila**  
1. Membuat map game (tanggal 21-23 Maret)

**Naila & Fabian**  
2. Fungsi Game (1 minggu mulai tanggal 24-30 Maret)  
- Characters movement (Naila)  
- Respawn characters (Fabian)  
- Fog shader (Fabian)  
- Interact with enemy (Naila)  
- System crafting (brewing stand) (Fabian)  
- Perpindahan scene (Naila)  
- Camera 2D in Godot 4 (Fabian)  
- Health bar (karakter & enemy) (Fabian)  
- CollisionShape (interaksi lingkungan sekitar) (Naila)

**Naila**  
3. Buat menu game (tanggal 2-3 April)

**Naila**  
4. Level selection (tanggal 4 April)

**Naila**  
5. Menu paused (tanggal 5-6 April)

**Fabian & Riski**  
6. Efek fade in out (tanggal 7-11 April)  
- Pergantian loading screen (karakter) ke main menu (Fabian)  
- Masuk ke cut scene (Riski)  
- Naik level (Fabian)  
- Selesai level 2 -> ke cutscene (Riski)  
- Selesai cut scene (Fabian)

---

Kalau ada tambahan task atau revisi, kabarin di Grub FLX Studio!

---
