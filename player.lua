-- player implementation closure
local function player(start_x,start_y)
  local public = {}
  
  local x = start_x
  local y = start_y
  local hspeed = 1
  
  function public.get_x() return x end
  function public.get_y() return y end
  function public.update() x = x + hspeed end
  
  return public
end

return player

