class_name Overlay
extends MarginContainer

@onready var debug_rich_text_label: RichTextLabel = %DebugRichTextLabel

func _ready() -> void:
	var r = DisplayServer.screen_get_usable_rect()
	
	self.debug_rich_text_label.text = "%s" % [ r ]
	
