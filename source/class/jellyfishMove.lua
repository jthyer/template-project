local HSPEED = 1

local function jellyfishMove(start_x,start_y)  
  local public = {}
  
  local x, y = start_x, start_y
  local sprite = { global.getAsset("sprite","jellyfishMove"),32,32 }  
  
  function public.update() 
    x = x + HSPEED
  end
  
  function public.get_x() return x end
  function public.get_y() return y end
  function public.getSprite() return sprite end
  
  return public
end

return jellyfishMove