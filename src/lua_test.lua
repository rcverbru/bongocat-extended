-- Load a placeholder image to ensure valid window dimensions
local cat = BongoSprite.loadFromFile("cats/hard_worker/cat.png")

local current_pressed_keys = {}
local previous_pressed_keys = {}

BongoWindow.create(Sfml.Style.None)
print("=== Key Press Debug Mode ===")
print("Press keys to see their internal key codes. Press ESC to quit.")

while BongoWindow.processEvents() == 0 do
  BongoWindow.clear(Sfml.Color.White)

  -- Draw something to enforce non-zero window size
  BongoWindow.draw(cat)

  BongoWindow.display()

  -- Update pressed keys
  for k = 1, BongoInput.KeyCount - 1 do
    current_pressed_keys[k] = isPressed(k)
  end

  -- Detect newly pressed keys
  for k = 1, BongoInput.KeyCount - 1 do
    if current_pressed_keys[k] and not previous_pressed_keys[k] then
      print(string.format("Pressed key code: %d", k))
      if k == BongoInput.Key.Escape then
        print("Exiting...")
        os.exit()
      end
    end
  end

  -- Update previous key state
  for k = 1, BongoInput.KeyCount - 1 do
    previous_pressed_keys[k] = current_pressed_keys[k]
  end
end
