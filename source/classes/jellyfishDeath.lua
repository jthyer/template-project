local jellyfishDeath = object:extend()

function jellyfishDeath:create()
  self.rotation = 0
  self.timer = 0
  sound.play("sfx_enemyDead")
end

function jellyfishDeath:sprite()
  self:spriteSet("jellyfishDeath")
end

function jellyfishDeath:update()
  self.timer = self.timer + 1
  
  if self.timer == 3 then
    self:instanceDestroy()
  end
end

return jellyfishDeath