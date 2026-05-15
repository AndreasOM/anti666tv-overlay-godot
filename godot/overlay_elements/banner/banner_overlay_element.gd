class_name BannerOverlayElement
extends OverlayElement

@export var background_color: Color = Color.BLUE
@export var focus_color: Color = Color.ORANGE
@onready var background: ColorRect = %Background
@onready var line_edit: LineEdit = %LineEdit

func _ready() -> void:
	self.background.color = self.background_color
	super._ready()
	
func _on_focus_entered() -> void:
	print_rich( "[color=orange] Banner: focus_entered" )
	if self.background == null:
		return
	self.background.color = self.focus_color
#	self.banner_label.add_theme_color_override("font_color", self.focus_color)
#	self.banner_label.text = "FOCUS"

func _on_focus_exited() -> void:
	print_rich( "[color=orange] Banner: focus_exited" )
	self.background.color = self.background_color
#	self.banner_label.remove_theme_color_override("font_color")

func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		print("ACCEPT")
		self.line_edit.editable = true
		var p = self.line_edit.text.length()
		self.line_edit.caret_column = p
		self.line_edit.focus_mode = Control.FOCUS_ALL
		self.line_edit.grab_focus.call_deferred()

func _input(event: InputEvent) -> void:
		
	if event.is_action_pressed("banner_toggle"):
		self.visible = !self.visible

	return
	var iemb = event as InputEventMouseButton
	if iemb != null:
		if iemb.pressed:
			self.visible = !self.visible


func _on_line_edit_text_submitted(new_text: String) -> void:
	self.grab_focus.call_deferred()
	self.line_edit.focus_mode = Control.FOCUS_NONE


func _on_line_edit_focus_exited() -> void:
	self.grab_focus.call_deferred()
	self.line_edit.focus_mode = Control.FOCUS_NONE
