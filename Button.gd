extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var count = 0

signal open(open)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_body_entered(body):
	$Sprite.frame = 1
	count += 1
	if count == 1:
		emit_signal("open", true)


func _on_Button_body_exited(body):
	count -= 1
	if count == 0:
		$Sprite.frame = 0
		emit_signal("open", false)
		
