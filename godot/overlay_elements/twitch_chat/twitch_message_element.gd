@tool
class_name TwitchMessageElement
extends MarginContainer

@onready var rich_text_label: RichTextLabel = %RichTextLabel
@export_tool_button("Set Test Text") var set_test_text_action = set_test_text

@export var text = "" : set = set_text

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#	self.set_text("Test [emote id=emotesv2_9b59df7cc5f94af6b46953e6da05d18c]")
	self.set_text("Test [emote id=emotesv2_9b59df7cc5f94af6b46953e6da05d18c] [emote id=emotesv2_40ea2dc0375d4443827a9c8c794d2e41]")
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

	

	# :TODO: for eid in eids:

	for eid in eids:
	#var eid = "emotesv2_9b59df7cc5f94af6b46953e6da05d18c"
		var emote_request = EmoteRequest.new()
		emote_request.url = "https://static-cdn.jtvnw.net/emoticons/v2/%s/default/light/4.0" % [ eid ]
		emote_request.eid = eid
		emote_request.succeeded.connect( _emote_request_succeeded )
		
		self.add_child( emote_request )
		emote_request.fetch()

func _emote_request_succeeded( image, eid ) -> void:
	var texture = ImageTexture.create_from_image(image)

	# Display the image in a TextureRect node.
	var texture_rect = TextureRect.new()
#	add_child(texture_rect)
	texture_rect.texture = texture

	self.rich_text_label.update_image(
		eid,
		1, #ImageUpdateMask.UPDATE_TEXTURE,
		texture, #img,
	)
	pass
	
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
