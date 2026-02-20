local spike = object:extend()

function spike:tag()
  self.enemy = true  
  self.spike = true
  self.enemySolid = true
end

function spike:sprite()
  self:spriteSet("spike")
  self:setMask(2,2,12,12)
end

return spike