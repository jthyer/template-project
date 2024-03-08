-- wall implementation closure
local function wall(start_x,start_y)
  local public = {}
  
  local x = start_x
  local y = start_y
  
  function public.get_x() return x end
  function public.get_y() return y end
  function public.update() end
  
  return public
end

return wall

