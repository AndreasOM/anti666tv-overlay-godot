class_name EmoteParser
extends RefCounted


const TYPE_TEXT := "text"
const TYPE_EMOTE := "emote"

# Captures only the id:
# [emote id=emotesv2_9b59df7cc5f94af6b46953e6da05d18c]
#static var _emote_regex: RegEx = RegEx.create_from_string(
#	r"\[emote id=([^\]]+)\]"
#)


static func parse(text: String) -> Array[Dictionary]:
	var chunks: Array[Dictionary] = []
	var last_pos := 0

	var _emote_regex: RegEx = RegEx.create_from_string(
		r"\[emote id=([^\]]+)\]"
	)

	for match_result: RegExMatch in _emote_regex.search_all(text):
		var match_start := match_result.get_start(0)
		var match_end := match_result.get_end(0)
		var emote_id := match_result.get_string(1)

		# Text before this emote.
		if match_start > last_pos:
			chunks.append({
				"type": TYPE_TEXT,
				"text": text.substr(last_pos, match_start - last_pos),
			})

		# The emote itself.
		chunks.append({
			"type": TYPE_EMOTE,
			"id": emote_id,
			"raw": match_result.get_string(0),
		})

		last_pos = match_end

	# Remaining text after the last emote.
	if last_pos < text.length():
		chunks.append({
			"type": TYPE_TEXT,
			"text": text.substr(last_pos),
		})

	return chunks
