tool
extends StaticBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export (int) var height setget set_height, get_height
func set_height(new_value):
	height = new_value
	update_sprites()

func get_height():
	return height # Getter must return a value.
	
export (bool) var open setget set_open, get_open
func set_open(new_value):
	open = new_value
	if open:
		open()
	else:
		close()

func get_open():
	return open # Getter must return a value.

var sprites = []
var body
var shape
var open_count = 0

func update_sprites():
	if 1 > height:
		return
	var sprites_node = $Sprites
	if sprites_node == null:
		return
	var childrens = sprites_node.get_children()
	for i in range(childrens.size()):
		sprites_node.remove_child(childrens[i])
	for i in range(height):
		sprites.append(Sprite.new())
		sprites_node.add_child(sprites[i])
		sprites[i].set_owner(self)
		sprites[i].texture = preload("res://Sprites/Gate.png")
		sprites[i].hframes = 3
		sprites[i].frame = 1
		sprites[i].position = Vector2(0,-16) * i
	
	sprites[height-1].frame = 0
	
	$CollisionShape2D.shape.extents = Vector2(16, 16 * height)
	$CollisionShape2D.position = Vector2(0, (-16 * height) + 16) # half height
	


func _process(delta):
	pass
	
func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		set_height(0)


func open():
	if sprites.size() == 0:
		return
	for i in range(1,height):
		sprites[i].visible = false
	sprites[0].frame = 0
	call_deferred("disable_collision", true)
	
func close():
	if sprites.size() == 0:
		return
	sprites[0].frame = 1
	for i in range(height):
		sprites[i].visible = true	
	sprites[height-1].frame = 0
	call_deferred("disable_collision", false)

func disable_collision(active):	
	$CollisionShape2D.set_disabled(active)

func change_state(open):
	if open:
		open_count += 1
		if open_count == 1:
			set_open(true)
	else: 
		open_count -= 1
		if open_count == 0:
			set_open(false)
