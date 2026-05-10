class_name Banner
extends MarginContainer


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("banner_toggle"):
		self.visible = !self.visible

	var iemb = event as InputEventMouseButton
	if iemb != null:
		if iemb.pressed:
			self.visible = !self.visible
