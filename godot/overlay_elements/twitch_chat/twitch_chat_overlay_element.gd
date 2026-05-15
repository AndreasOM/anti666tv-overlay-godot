class_name TwitchChatOverlayElement
extends OverlayElement

@onready var omg_twitch_channel_node: OmgTwitchChannelNode = %OmgTwitchChannelNode
@onready var v_box_container: VBoxContainer = %VBoxContainer

var _pending_messages: Array[ String ] = []

func _ready() -> void:
	while !self._pending_messages.is_empty():
		var msg = self._pending_messages.pop_front()
		self.add_message( msg )
		
func _on_omg_twitch_channel_node_message_received(msg: String) -> void:
	print("msg: %s" % [ msg ])
	if self.v_box_container == null:
		self._pending_messages.push_back( msg )
		return
		
	self.add_message(msg)

func add_message(msg: String) -> void:
	var l = Label.new()
	l.add_theme_font_size_override("font_size", 32)
	l.text = ">> %s" % [ msg ]
	
	self.v_box_container.add_child( l )
	pass
