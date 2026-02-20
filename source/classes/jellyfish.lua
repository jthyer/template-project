local jellyfish = object:extend()

function jellyfish:tag()
  self.enemy = true  
end

function jellyfish:sprite()
  self:spriteSet("jellyfishStill")
  self:setMask(4,8,24,20)
end

function jellyfish:die()
  self:instanceCreate("jellyfishDeath",self.x,self.y)
  self:instanceDestroy()
end

return jellyfish