local bullet = object:extend()

local SPEED = 5

function bullet:tag()
  self.enemy = true 
  self.spike = true
end

function bullet:sprite()
  self:spriteSet("bullet")
  self:setMask(4,4,8,8)
end

function bullet:update()
  self:move()
end

function bullet:aimed()
  local player = manager.getObjectByTag("player")
  local target_x, target_y = player.x + 8, player.y + 8
 
  self:setVectorAimed(target_x,target_y,SPEED,true)
end

function bullet:fixed(angle)
  self:setVector(angle,SPEED,true)
end

return bullet