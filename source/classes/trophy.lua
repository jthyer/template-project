local trophy = object:extend()

function trophy:tag()
  self.win = true
end

function trophy:sprite()
  self:spriteSet("trophy")
  self:setMask(0,0,120,120)
end

function trophy:update()
  if sound.musicIsPlaying() ~= "bgm_ending" and scene.getSceneNumber() == 7 then
    sound.musicPlay("bgm_ending")
  end
end

return trophy