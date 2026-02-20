local jellyfishBoss = require("source.classes.jellyfish"):extend()

local SHOTSPEED = 2
local SHOTINTERVAL = 60

function jellyfishBoss:create()
  self.shotTimer = SHOTINTERVAL
end

function jellyfishBoss:sprite()
  self:spriteSet("jellyfishBoss")
  self:setMask(4,8,24,20)
end

function jellyfishBoss:update()
  if self.shotTimer == 0 then
    self:loadBossWave()
    self.shotTimer = SHOTINTERVAL
  end
  
  self.shotTimer = self.shotTimer - 1
end

function jellyfishBoss:loadBossWave()
  for i=1,10 do
    local b = manager.addObject("bullet",self.x+8,self.y+8)
    b:fixed(math.rad(i*36))
  end
end

return jellyfishBoss