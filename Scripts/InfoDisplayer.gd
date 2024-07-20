extends Panel

@onready var text_displayer = $RichTextLabel

var text_test = load("res://Recources/Critique/Wind.txt")
# Called when the node enters the scene tree for the first time.
func _ready():
	var bbcode_text = convert_markdown_to_bbcode(text_test)
	bbcode_text = bbcode_text.replace("[code]","[code]").replace("[/code]","[/code]")
	bbcode_text = bbcode_text.replace("[list]","[list]").replace("[/list]","[/list]")
	bbcode_text = bbcode_text.replace("[*]","[*]")
	text_displayer.set_bbcode(bbcode_text)

func display_data(dataname):
	pass

func convert_markdown_to_bbcode(markdown: String) -> String:
	var bbcode = markdown
	bbcode = bbcode.replace("## ", "[center][b]").replace("\n", "[/b][/center]\n")
	bbcode = bbcode.replace("**", "[b]").replace("*", "[i]")
	bbcode = bbcode.replace("- ", "[*]")
	bbcode = "[list]" + bbcode + "[/list]"
	return bbcode
