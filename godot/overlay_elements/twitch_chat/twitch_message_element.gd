@tool
class_name TwitchMessageElement
extends MarginContainer

@onready var rich_text_label: RichTextLabel = %RichTextLabel
@export_tool_button("Set Test Text") var set_test_text_action = set_test_text

@export var text = "" : set = set_text

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.set_text("Test [emote id=emotesv2_9b59df7cc5f94af6b46953e6da05d18c]")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_test_text() -> void:
	self.set_text(
		"Test [emote id=emotesv2_9b59df7cc5f94af6b46953e6da05d18c] <---- Test [emote id=emotesv2_9b59df7cc5f94af6b46953e6da05d18c] <----")
	pass	
	
enum Mode {
	TEXT,
	EMOTE
}
func set_text( text: String ) -> void:
	self.rich_text_label.text = ""

	var eids: Array[ String ] = []
	var chunks = EmoteParser.parse( text )
	for chunk in chunks:
		match chunk["type"]:
			EmoteParser.TYPE_TEXT:
				var t = chunk["text"]
				self.rich_text_label.add_text( t )
			EmoteParser.TYPE_EMOTE:
				var eid = chunk["id"]
				var img = Texture2D.new()
				img = load("res://icon.svg")
				self.rich_text_label.add_image(
					img,
					28, 28,
					Color.WHITE, #Color.DEEP_PINK
					5,
					Rect2(),
					eid,
				)
				eids.push_back( eid )
		print( chunk )
	
#	var m = Mode.TEXT
#	var emote_len = 0
#	for i in range(0, text.length()):
#	#for c in text:
#		var c = text[ i ]
#		match m:
#			Mode.TEXT:
#				if c == "[":
#					m = Mode.EMOTE
#					emote_len = 1
#					for j in range( i+1, text.length()):
#						var cj = text[ j ]
#						if cj == "]":
#							emote_len = j - i
#							var img = Texture2D.new()
#							img = load("res://icon.svg")
#							self.rich_text_label.add_image(
#								img,
#								28, 28,
#								Color.WHITE, #Color.DEEP_PINK
##								Rect2(),
#								"FUU",
#							)
#					continue
#				self.rich_text_label.add_text( c )
#			Mode.EMOTE:
#				emote_len -= 1
#				if emote_len <= 0:
#					m = Mode.TEXT
##				pass
#		print(c)
#	self.rich_text_label.text = text


	# :TODO: for eid in eids:
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(self._http_request_completed)
#	var error = http_request.request("https://placehold.co/28.png")
	var error = http_request.request("https://static-cdn.jtvnw.net/emoticons/v2/emotesv2_9b59df7cc5f94af6b46953e6da05d18c/default/light/4.0")
	
	if error != OK:
		push_error("An error occurred in the HTTP request.")



#	var img = load("res://assets/bugs/anti666tv-round-150.png")
#	self.rich_text_label.update_image(
#		"FUU",
#		1, #ImageUpdateMask.UPDATE_TEXTURE,
#		img,
#	)
#	pass

func _http_request_completed(result, response_code, headers, body):
	if result != HTTPRequest.RESULT_SUCCESS:
		push_error("Image couldn't be downloaded. Try a different image.")

	var image = Image.new()
	var error = image.load_png_from_buffer(body)
	if error != OK:
		push_error("Couldn't load the image.")

	var texture = ImageTexture.create_from_image(image)

	# Display the image in a TextureRect node.
	var texture_rect = TextureRect.new()
#	add_child(texture_rect)
	texture_rect.texture = texture

	self.rich_text_label.update_image(
		"FUU",
		1, #ImageUpdateMask.UPDATE_TEXTURE,
		texture, #img,
	)
