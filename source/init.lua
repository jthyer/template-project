--[[
init.lua

Initializing code for all scenes and individual scenes.
Good for GUI objects, maintaining state, etc.
]]--

local init = {}

function init.load(sceneNumber)
  if sceneNumber == 1 then
    
  end
end

-- return default background color
function init.backgroundColor()
  return 0, 0, 0
end

-- return default background texture 
function init.backgroundTexture()
  return "bg_night"
end

return init