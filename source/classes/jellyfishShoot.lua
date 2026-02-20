local jellyfishShoot = require("source.classes.jellyfish"):extend()

local SHOTSPEED = 2
local SHOTINTERVAL = 60

function jellyfishShoot:create()
  self.shotTimer = SHOTINTERVAL
end

function jellyfishShoot:sprite()
  self:spriteSet("jellyfishShoot")
  self:setMask(4,8,24,20)
end

function jellyfishShoot:update()
  if self.shotTimer == 0 then
    local b = manager.addObject("bullet",self.x+8,self.y+8)
    b:aimed()
    sound.play("sfx_enemyShoot", true)
    self.shotTimer = SHOTINTERVAL
  end
  
  self.shotTimer = self.shotTimer - 1
end

return jellyfishShoot