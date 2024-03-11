local HSPEED = 1

local function jellyfish(c,start_x,start_y)  
  local public = {}
  
  local class, x, y = c, start_x, start_y
  local sprite = global.getAsset("sprite",class)
  
  function public.update() 
    if class == "jellyfishMove" then
      x = x + HSPEED
    end
  end
  
  function public.drawInfo() return x, y, sprite end
  function public.getSprite() return sprite end
  
  return public
end

return jellyfish