local lilly = {}
local private = {}

local SPEED = 3
local JUMP = 7
local GRAVITY = 0.2

function lilly:load()
  self.sprite = global.getAsset("sprite","lillyR")
  self.width = 32
  self.height = 32
  self.hspeed = 0
  self.vspeed = 0
end

function lilly:update(p)
  private.horMovement(self,p)
  private.vertMovement(self,p)
end

function private:horMovement(p)
  if kb.left() then
    self.hspeed = -SPEED
  elseif kb.right() then
    self.hspeed = SPEED    
  else
    self.hspeed = 0
  end
  
  local new_x = self.x + self.hspeed
  local collide_x = p.checkCollisionWalls(new_x,self.y,
    self.width,self.height)
  
  if not collide_x then
    self.x = new_x
  else
    self.x = util.round(self.x/4) * 4
  end  
end

function private:vertMovement(p)
  local grounded = p.checkCollisionFloor(self.x,self.y+1,
    self.width,self.height)

    if kb.jumpPressed() then
      self.vspeed = -JUMP
    end
  
  if grounded then
    if kb.jumpPressed() then
      self.vspeed = -JUMP
    end
  else  
    self.vspeed = self.vspeed + GRAVITY
  end  

  local new_y = self.y + self.vspeed
  local collide_y_floor = p.checkCollisionFloor(self.x,new_y,
    self.width,self.height)
  local collide_y_ceil = p.checkCollisionCeil(self.x,new_y,
    self.width,self.height)
  
  if not (collide_y_floor or collide_y_ceil) then
    self.y = new_y
  else
    self.y = util.round(self.y/16) * 16
    if collide_y_floor then
      self.vspeed = 0
      self.vaccel = 0
    end
  end 

end


return lilly