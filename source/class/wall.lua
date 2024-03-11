local function wall(start_x,start_y)  
  local public = {}
  
  local x, y = start_x, start_y
  local sprite = { nil, 16, 16 }
  
  function public.get_x() return x end
  function public.get_y() return y end
  function public.getSolidWidth() return 16 end
  function public.getSolidHeight() return 16 end
  
  return public
end

return wall