--==========================--
-- Just testing lua support --
--==========================----------------------------
-- For anyone reading this... my code for drawing the --
-- paw is poor. Please ignore this as it'll be fixed  --
-- before this cat comes out (into production)        --
--------------------------------------------------------

-- Create a placeholder keyMap — we'll fill it later
local keyMap = {}

-- laad our images. LOAD BEFORE CREATING THE WINDOW!
local cat = BongoSprite.loadFromFile("cats/hard_worker/cat.png")

-- Eyes
local eyes_1 = BongoSprite.loadFromFile("cats/hard_worker/eyes1.png")
local eyes_2 = BongoSprite.loadFromFile("cats/hard_worker/eyes2.png")

-- Paws
local p_l_up = BongoSprite.loadFromFile("cats/hard_worker/left_up.png")
local p_l_down = BongoSprite.loadFromFile("cats/hard_worker/left_down.png")
local p_r_up = BongoSprite.loadFromFile("cats/hard_worker/right_up.png")
local p_r_down = BongoSprite.loadFromFile("cats/hard_worker/right_down.png")

local k_space = BongoSprite.loadFromFile("cats/keyboard/keys/space.png")
local current_pressed_keys = {}
local previous_pressed_keys = {}
local draw_key = BongoInput.Key.None
local previous_paw = 0

left_board = {'1', '2', '3', '4', '5', '6', 'q', 'w', 'e', 'r', 't', 'a', 's', 'd', 'f', 'g', 'z', 'x', 'c', 'v', 'b'}
right_board = {'7', '8', '9', '0', '-', '=', 'y', 'u', 'i', 'o', 'p', '[', ']', 'n', 'm', ',', '.', '/'}

local function allFalse(t)
  for _, v in pairs(t) do
    if v then return false end
  end
  return true
end

BongoWindow.create(3840, 2400, Sfml.Style.None, { 0, 0 })

-- Dump keys and build a basic lowercase keyMap
for k, v in pairs(BongoInput.Key) do
  if type(k) == "string" and #k == 1 then
    keyMap[v] = k:lower()
  end
end

while BongoWindow.processEvents() == 0 do
  BongoWindow.clear(Sfml.Color.White)

  -- draw the bg sprite to the window
  BongoWindow.draw(cat)
  BongoWindow.draw(eyes_1)

  -- Update pressed keys
  for k = 1, BongoInput.KeyCount - 1, 1 do
    current_pressed_keys[k] = isPressed(k)
  end

  -- Get newest pressed key
  for k = 1, BongoInput.KeyCount - 1, 1 do
    if current_pressed_keys[k] and not previous_pressed_keys[k] then
      draw_key = k
      break
    end
  end

  -- Update if old key lifted and new one exists
  if previous_pressed_keys[draw_key] and not current_pressed_keys[draw_key] then
    for k, value in pairs(current_pressed_keys) do
      if value then
        draw_key = k
        break
      end
    end
  end

  -- Build lookup tables
  local left_lookup = {}
  for _, key in ipairs(left_board) do left_lookup[key] = true end

  local right_lookup = {}
  for _, key in ipairs(right_board) do right_lookup[key] = true end

  -- 🐾 Paw logic: check which side(s) are pressed
  local left_pressed = false
  local right_pressed = false
  local skip_normal_paw_logic = false

  -- Check for spacebar first
  if isPressed(BongoInput.Key.space) then
    skip_normal_paw_logic = true
    BongoWindow.draw(p_l_down)
    BongoWindow.draw(p_r_down)
  end

  -- Continue checking other keys if space wasn't pressed
  if not skip_normal_paw_logic then
    for k = 1, BongoInput.KeyCount - 1 do
      if current_pressed_keys[k] then
        local key_str = keyMap[k]
        if key_str then
          if left_lookup[key_str] then
            left_pressed = true
          elseif right_lookup[key_str] then
            right_pressed = true
          end
        end
      end
    end

    if left_pressed and right_pressed then
      BongoWindow.draw(p_l_down)
      BongoWindow.draw(p_r_down)
    elseif left_pressed then
      BongoWindow.draw(p_l_down)
      BongoWindow.draw(p_r_up)
    elseif right_pressed then
      BongoWindow.draw(p_r_down)
      BongoWindow.draw(p_l_up)
    else
      BongoWindow.draw(p_l_up)
      BongoWindow.draw(p_r_up)
    end
  end


  for k = 1, BongoInput.KeyCount - 1, 1 do
    previous_pressed_keys[k] = current_pressed_keys[k]
  end

  BongoWindow.display()
end

