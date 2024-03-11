local function wall(c,start_x,start_y)  
  local public = {}
  
  local class, x, y = c, start_x, start_y
  local hitbox = { 
    x = x,
    y = y,
    width = 16,
    height = 16,
  }
  
  public.solid = true
  function public.hitbox() return hitbox end
  function public.getSolidWidth() return 16 end
  function public.getSolidHeight() return 16 end
  
  return public
end

return wall