extends MarginContainer

@onready var overlay_sub_viewport: SubViewport = %OverlaySubViewport
@onready var overlay: MarginContainer = %Overlay

func _ready() -> void:
	pass
	
func _unhandled_input(event: InputEvent) -> void:
	self.overlay_sub_viewport.push_input( event )
