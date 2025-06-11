
--==========================--
-- Just testing lua support --
--==========================----------------------------
-- For anyone reading this... my code for drawing the --
-- paw is poor. Please ignore this as it'll be fixed  --
-- before this cat comes out (into production)        --
--------------------------------------------------------

local height = 180
local width = 320
local scale = 1

-- Create a placeholder keyMap — we'll fill it later
local keyMap = {}

-- Load images
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

local left_board = {'1', '2', '3', '4', '5', '6', 'q', 'w', 'e', 'r', 't', 'a', 's', 'd', 'f', 'g', 'z', 'x', 'c', 'v', 'b'}
local right_board = {'7', '8', '9', '0', '-', '=', 'y', 'u', 'i', 'o', 'p', '[', ']', 'n', 'm', ',', '.', '/', 'h', 'j', 'k', 'l', ';', "'"}

local function allFalse(t)
  for _, v in pairs(t) do
    if v then return false end
  end
  return true
end

BongoWindow.create((scale * width), (scale * height))

-- Debug dump of all key enums at runtime
for keyName, keyVal in pairs(BongoInput.Key) do
  print("enum:", keyName, keyVal)
end

-- Static keyMap — replace these key codes with the correct ones from your platform
-- local keyMap = {
--   -- Top row: QWERTYUIOP
--   [81] = 'q', [87] = 'w', [69] = 'e', [82] = 'r', [84] = 't',
--   [89] = 'y', [85] = 'u', [73] = 'i', [79] = 'o', [80] = 'p',

--   -- Home row: ASDFGHJKL
--   [97] = 'a', [83] = 's', [68] = 'd', [100] = 'd',
--   [70] = 'f', [71] = 'g', [72] = 'h', [74] = 'j', [75] = 'k',
--   [76] = 'l',

--   -- Bottom row: ZXCVBNM
--   [90] = 'z', [88] = 'x', [67] = 'c', [99] = 'c', [86] = 'v',
--   [66] = 'b', [98] = 'b', [78] = 'n', [77] = 'm',

--   -- Number row: 1–0
--   [49] = '1', [50] = '2', [51] = '3', [52] = '4', [53] = '5',
--   [54] = '6', [55] = '7', [56] = '8', [57] = '9', [48] = '0',

--   -- Extra
--   [32] = 'space',
-- }

local keyMap = {
  -- Letters
  [81] = 'q', [87] = 'w', [69] = 'e', [82] = 'r', [84] = 't',
  [89] = 'y', [85] = 'u', [73] = 'i', [79] = 'o', [80] = 'p',
  [97] = 'a', [83] = 's', [68] = 'd', [100] = 'd',
  [70] = 'f', [71] = 'g', [72] = 'h', [74] = 'j', [75] = 'k', [76] = 'l',
  [90] = 'z', [88] = 'x', [67] = 'c', [99] = 'c', [86] = 'v',
  [66] = 'b', [98] = 'b', [78] = 'n', [77] = 'm',

  -- Number row
  [49] = '1', [50] = '2', [51] = '3', [52] = '4', [53] = '5',
  [54] = '6', [55] = '7', [56] = '8', [57] = '9', [48] = '0',

  -- Space bar fix
  [65] = 'space',
}

while BongoWindow.processEvents() == 0 do
  BongoWindow.clear(Sfml.Color.White)
  BongoWindow.draw(cat)
  BongoWindow.draw(eyes_1)

  for k = 1, BongoInput.KeyCount - 1, 1 do
    current_pressed_keys[k] = isPressed(k)
  end

  for k = 1, BongoInput.KeyCount - 1, 1 do
    if current_pressed_keys[k] and not previous_pressed_keys[k] then
      draw_key = k
      break
    end
  end

  if previous_pressed_keys[draw_key] and not current_pressed_keys[draw_key] then
    for k, value in pairs(current_pressed_keys) do
      if value then
        draw_key = k
        break
      end
    end
  end

  local left_lookup = {}
  for _, key in ipairs(left_board) do left_lookup[key] = true end

  local right_lookup = {}
  for _, key in ipairs(right_board) do right_lookup[key] = true end

  local left_pressed = false
  local right_pressed = false
  local skip_normal_paw_logic = false

  if isPressed(32) then -- space keycode
    skip_normal_paw_logic = true
    BongoWindow.draw(p_l_down)
    BongoWindow.draw(p_r_down)
    BongoWindow.draw(eyes_2)
  end

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
