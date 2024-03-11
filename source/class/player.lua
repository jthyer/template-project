local SPEED = 3
local JUMP = 7
local GRAVITY = 0.2

local function player(c,start_x,start_y,checkObjects)  
  local public = {}
  
  local class, x, y = c, start_x, start_y
  local sprite = global.getAsset("sprite","lillyR")
  local hspeed, vspeed = 0, 0
  
  local hitbox = {}
  hitbox = {x=x+8,y=y+8,width=16,height=24}
  
  local function checkCollisionWalls(check_x,check_y,checkWidth,checkHeight,
    floorOnly,ceilOnly)
    local function f(obj) 
      local collision = false
      if obj.solid then
        local x, y, w, h = obj.hitbox().x, obj.hitbox().y,
          obj.hitbox().width, obj.hitbox().height
          
        if util.checkOverlap(check_x,check_y,checkWidth,checkHeight,x,y,w,h) then
          collision = true
        end
      end
      
      
      
      
     --[[ if obj.getSolidWidth ~= nil and 
        (floorOnly == nil or y <= obj.get_y()) and
        (ceilOnly == nil or y > obj.get_y()) and
        util.checkOverlap(check_x,check_y,checkWidth,checkHeight,
          obj.get_x(),obj.get_y(),obj.getSolidWidth(),obj.getSolidHeight()) then--]]
        --collision = true
      --end
      
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

    local collide_x = checkCollisionWalls(hitbox.x+hspeed,hitbox.y,
      hitbox.width,hitbox.height)
    if not collide_x then
      x = x + hspeed
    else
      x = util.round(x/4) * 4
    end  
  end
  
  local function vertMovement()
    local grounded = checkCollisionWalls(hitbox.x,hitbox.y+1,
      hitbox.width,hitbox.height,true)
  
    if grounded then
      if kb.jumpPressed() then
        vspeed = -JUMP
      end
    else  
      vspeed = vspeed + GRAVITY
    end  

    local new_y = y + vspeed
    local collide_y_floor = checkCollisionWalls(hitbox.x,hitbox.y+vspeed,
      hitbox.width,hitbox.height,true)
    local collide_y_ceil = checkCollisionWalls(hitbox.x,hitbox.y+vspeed,
      hitbox.width,hitbox.height,nil,true)
    
    if not (collide_y_floor or collide_y_ceil) then
      y = y + vspeed
    else
      y = util.round(y/8) * 8
      if collide_y_floor then
        vspeed = 0
        --vaccel = 0
      end
    end
  end
  
  local function updateHitbox()
    hitbox.x = x+8
    hitbox.y = y+8
  end
  
  function public.update() 
    horMovement()
    vertMovement()
    updateHitbox()
  end
  
  function public.drawInfo() return x, y, sprite end
  function public.get_y() return y end
  function public.getSprite() return sprite end

  return public
end

return player