local M = {}

function M.strip_alpha(hex)
  if #hex == 9 then
    return hex:sub(1, 7)
  end
  return hex
end

local function hex_to_rgb(hex)
  hex = M.strip_alpha(hex):gsub("#", "")
  return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16)
end

function M.luminance(hex)
  local r, g, b = hex_to_rgb(hex)
  local function channel(value)
    value = value / 255
    if value <= 0.03928 then
      return value / 12.92
    end
    return ((value + 0.055) / 1.055) ^ 2.4
  end
  return 0.2126 * channel(r) + 0.7152 * channel(g) + 0.0722 * channel(b)
end

function M.is_light(hex)
  return M.luminance(hex) > 0.6
end

function M.contrast(a, b)
  local left = M.luminance(a)
  local right = M.luminance(b)
  local lighter = math.max(left, right)
  local darker = math.min(left, right)
  return (lighter + 0.05) / (darker + 0.05)
end

function M.blend(from, to, percent)
  local fr, fg, fb = hex_to_rgb(from)
  local tr, tg, tb = hex_to_rgb(to)
  local function channel(a, b)
    return math.floor(a + (b - a) * percent + 0.5)
  end
  return string.format("#%02x%02x%02x", channel(fr, tr), channel(fg, tg), channel(fb, tb))
end

-- Raise a colour's contrast against the background until it reaches `minimum`.
-- This keeps the palette identity for colours that are already readable and
-- only nudges the ones that would otherwise disappear (for example Paris
-- comments, whose color7 is the same as its background).
function M.readable(colour, background, minimum)
  if M.contrast(colour, background) >= minimum then
    return M.strip_alpha(colour)
  end

  local target = M.is_light(background) and "#000000" or "#ffffff"
  for percent = 0.1, 1.0, 0.1 do
    local candidate = M.blend(colour, target, percent)
    if M.contrast(candidate, background) >= minimum then
      return candidate
    end
  end
  return target
end

function M.surface(palette)
  return M.blend(palette.background, palette.foreground, 0.1)
end

function M.comment(palette)
  local background = palette.background
  local candidates = { palette.color7, palette.color8, palette.foreground }
  if palette.comment then
    table.insert(candidates, 1, palette.comment)
  end
  for _, candidate in ipairs(candidates) do
    if candidate and M.contrast(candidate, background) >= 3.0 then
      return M.strip_alpha(candidate)
    end
  end
  return M.readable(palette.color7 or palette.foreground, background, 3.0)
end

return M
