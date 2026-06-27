class_name TwitchChatOverlayElement
extends OverlayElement

@onready var omg_twitch_channel_node: OmgTwitchChannelNode = %OmgTwitchChannelNode
@onready var v_box_container: VBoxContainer = %VBoxContainer

var _pending_messages: Array[ String ] = []

const TWITCH_MESSAGE_ELEMENT = preload("uid://nhm4is6lrgt3")

func _ready() -> void:
	while !self._pending_messages.is_empty():
		var msg = self._pending_messages.pop_front()
		self.add_message( msg )
		
func _process(delta: float) -> void:
	self.omg_twitch_channel_node.poll()
	
func _on_omg_twitch_channel_node_message_received(msg: String) -> void:
	print("msg: %s" % [ msg ])
	if self.v_box_container == null:
		self._pending_messages.push_back( msg )
		return
		
	self.add_message(msg)

func add_message(msg: String) -> void:
	if msg == "!clear":
		self.clear_messages()
		return

	var l = TWITCH_MESSAGE_ELEMENT.instantiate()
	# var l = TwitchMessageElement.new()
	# l.add_theme_font_size_override("font_size", 32)
	# l.text = ">> %s" % [ msg ]
	# l.set_text( msg )
	l.text = msg
	
	self.v_box_container.add_child( l )


func clear_messages() -> void:
	if self.v_box_container == null:
		return
	for c in self.v_box_container.get_children():
		var l = c as Label;
		if l == null:
			continue
		l.queue_free()
		self.v_box_container.remove_child( l )
		
