extends Spatial

const fire_rate = 0.4
const clip_size = 13
const reload_rate = 1
const default_position = Vector3()
const ads_position = Vector3()

onready var player = $"../../../"
onready var walk_anim = $"../../../WalkAnim"
onready var animator = $"Animator"
onready var hud_overlay_ammo = $"../../HUDOverlay/Ammo"
onready var raycast = $"../RayCast"
onready var first_person_camera = $".."

var current_ammo = 0
var can_fire = true
var is_reloading = false

func _process(_delta):
	if is_reloading:
		hud_overlay_ammo.set_text("Reloading..")
	else:
		hud_overlay_ammo.set_text("Ammo: %d/%d" % [current_ammo, clip_size])
	if Input.is_action_pressed("game_primary_fire") and not player.is_dead() and can_fire:
		if current_ammo > 0 and not is_reloading:
			fire()
		elif not is_reloading:
			reload()
	if Input.is_action_just_released("game_weapon_reload") and not player.is_dead():
		if current_ammo < clip_size and not is_reloading:
			reload()
	if Input.is_action_pressed("game_secondary_fire"):
		first_person_camera.set_fov(lerp(first_person_camera.fov, 50, 0.3))
	else:
		first_person_camera.set_fov(lerp(first_person_camera.fov, 70, 0.3))

func validate_collision():
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		
		if collider.is_in_group("Players"):
			var decreased_health = collider.get_translation().z - get_translation().z
			
			if decreased_health > 0:
				collider.decrease_health(decreased_health)
		elif collider.is_in_group("TNTs"):
			collider.explode()

func fire():
	if animator.is_playing():
		animator.stop()
	
	can_fire = false
	current_ammo -= 1
	validate_collision()
	animator.play("Weapon-Fire-Anim")
	
	yield(get_tree().create_timer(fire_rate), "timeout")
	can_fire = true

func reload():
	is_reloading = true
	animator.play("Weapon-Reload-Anim")
	yield(get_tree().create_timer(reload_rate), "timeout")
	current_ammo = clip_size
	is_reloading = false
