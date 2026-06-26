class_name EmoteRequest
extends Node

signal succeeded( image: Image, eid: String )

@export var url: String = ""
@export var eid: String = ""


func fetch() -> void:
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(self._http_request_completed)
	var error = http_request.request( self.url )
	if error != OK:
		push_error("An error occurred in the HTTP request.")

	pass
	
func _http_request_completed(result, response_code, headers, body):
	if result != HTTPRequest.RESULT_SUCCESS:
		push_error("Image couldn't be downloaded. Try a different image.")

	var image = Image.new()
	var error = image.load_png_from_buffer(body)
	if error != OK:
		push_error("Couldn't load the image. %d" % [ error ])
		print_rich("[color=orange] Couldn't load the image %s" %[ self.url ])
	else:
		self.succeeded.emit( image, self.eid )
