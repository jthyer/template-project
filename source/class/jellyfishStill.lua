local function jellyfishStill(start_x,start_y)  
  local public = {}
  
  local x, y = start_x, start_y
  local sprite = { global.getAsset("sprite","jellyfishStill"),32,32 }  
  
  function public.get_x() return x end
  function public.get_y() return y end
  function public.getSprite() return sprite end
  
  return public
end

return jellyfishStill