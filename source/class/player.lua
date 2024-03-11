local SPEED = 3
local JUMP = 7
local GRAVITY = 0.2

local function player(start_x,start_y,checkObjects)  
  local public = {}
  
  local x, y = start_x, start_y
  local sprite = global.getAsset("sprite","lillyR")
  local hspeed, vspeed = 0, 0
  
  local hitbox = {}
  hitbox.solid = {x=8,y=8,width=16,height=24}
  
  local function checkCollisionWalls(check_x,check_y,checkWidth,checkHeight,
    floorOnly,ceilOnly)
    local function f(obj) 
      local collision = false
      if obj.getSolidWidth ~= nil and 
        (floorOnly == nil or y <= obj.get_y()) and
        (ceilOnly == nil or y > obj.get_y()) and
        util.checkOverlap(check_x,check_y,checkWidth,checkHeight,
          obj.get_x(),obj.get_y(),obj.getSolidWidth(),obj.getSolidHeight()) then
        collision = true
      end
      
      return collision 
    end
    return checkObjects(f)
  end
  
  local function horMovement()
    if kb.left() then
      hspeed = -SPEED
    elseif kb.right() then
      hspeed = SPEED    
    else
      hspeed = 0
    end
  
    local new_x = x + hspeed
    local collide_x = checkCollisionWalls(new_x+hitbox.solid.x,y+hitbox.solid.y,
      hitbox.solid.width,hitbox.solid.height)
    if not collide_x then
      x = new_x
    else
      x = util.round(x/4) * 4
    end  
  end
  
  local function vertMovement()
    local grounded = checkCollisionWalls(x+hitbox.solid.x,y+hitbox.solid.y+1,
      hitbox.solid.width,hitbox.solid.height,true)
  
    if grounded then
      if kb.jumpPressed() then
        vspeed = -JUMP
      end
    else  
      vspeed = vspeed + GRAVITY
    end  

    local new_y = y + vspeed
    local collide_y_floor = checkCollisionWalls(x+hitbox.solid.x,new_y+hitbox.solid.y+1,
      hitbox.solid.width,hitbox.solid.height,true)
    local collide_y_ceil = checkCollisionWalls(x+hitbox.solid.x,y+hitbox.solid.y+1,
      hitbox.solid.width,hitbox.solid.height,nil,true)
    
    if not (collide_y_floor or collide_y_ceil) then
      y = new_y
    else
      y = util.round(y/16) * 16
      if collide_y_floor then
        vspeed = 0
        --vaccel = 0
      end
    end
  end
  
  function public.update() 
    horMovement()
    vertMovement()
  end
  
  function public.get_x() return x end
  function public.get_y() return y end
  function public.getSprite() return sprite end

  return public
end

return player