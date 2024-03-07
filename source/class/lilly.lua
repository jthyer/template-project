local lilly = {}
local private = {}

local SPEED = 3

function lilly:load()
  self.sprite = global.getAsset("sprite","lillyR")
  self.width = 32
  self.height = 32
  self.hspeed = 0
  self.vspeed = 0
end

function lilly:update(p)
  private.horMovement(self,p)
  --private.checkWalls(self,p)
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

function private:checkWalls(p)

  
end

return lilly