# Boot scene - iOS prototype with touch button and counter
extends Node2D

var counter: int = 0
var counter_label: Label
var increment_button: Button

func _ready() -> void:
    load_counter()

    var canvas_layer := CanvasLayer.new()
    add_child(canvas_layer)

    counter_label = Label.new()
    counter_label.name = "CounterLabel"
    counter_label.position = Vector2(500, 300)
    counter_label.text = "Contador: " + str(counter)
    canvas_layer.add_child(counter_label)

    increment_button = Button.new()
    increment_button.name = "IncrementButton"
    increment_button.position = Vector2(500, 400)
    increment_button.size = Vector2(200, 100)
    increment_button.text = "Incrementar"
    canvas_layer.add_child(increment_button)
    increment_button.pressed.connect(_on_button_pressed)

    print("Boot scene ready - counter: ", counter)


func load_counter() -> void:
    var path = "user://boot_counter.save"
    if FileAccess.file_exists(path):
        var file = FileAccess.open(path, FileAccess.READ)
        if file:
            counter = file.get_32()
            file.close()


func save_counter() -> void:
    var path = "user://boot_counter.save"
    var file = FileAccess.open(path, FileAccess.WRITE)
    if file:
        file.store_32(counter)
        file.close()


func _on_button_pressed() -> void:
    counter += 1
    counter_label.text = "Contador: " + str(counter)
    save_counter()
