local jellyfishMove = require("source.classes.jellyfish"):extend()

local SPEED = 2

function jellyfishMove:create()
  -- move left or right depending on x position for variation  
  self.hspeed = SPEED * (((self.x/16) % 2) * -2 + 1)
end

function jellyfishMove:sprite()
  self:spriteSet("jellyfishMove")
  self:setMask(4,8,24,20)
end

function jellyfishMove:update()
  local collide = self:moveIfNoSolidHorizontal()
  if collide then
    self.hspeed = self.hspeed * -1
  end
end

return jellyfishMove