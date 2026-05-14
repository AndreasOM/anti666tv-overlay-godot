class_name OverlayElement
extends MarginContainer

func _ready() -> void:
	self.focus_entered.connect( _on_focus_entered )
	self.focus_exited.connect( _on_focus_exited )
	
func _on_focus_entered() -> void:
	print_rich( "[color=orange] OverlayElement: focus_entered" )

func _on_focus_exited() -> void:
	print_rich( "[color=orange] OverlayElement: focus_exited" )
