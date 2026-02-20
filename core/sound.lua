--[[
sound.lua

My most redundant interace. Just a few things I want that Love
doesn't pack in with the sound player out of the box.
]]--

local sound = {}

local music 
local musicIndex

function sound.play(index, noOverlap)
  local currentSound
  if noOverlap then
    currentSound = asset.sound[index]
  else
    currentSound = asset.sound[index]:clone()
  end
  currentSound:play()
end

function sound.musicPlay(index)
  if music ~= nil then
    sound.musicStop()
  end
  
  musicIndex = index
  
  music = asset.sound[index]
  music:setLooping(true)
  if index == "bgm_junior" then
    music:setVolume(0.15)
  else
    music:setVolume(0.25)
  end
  music:play()
end

function sound.musicIsPlaying()
  return musicIndex
end

function sound.musicStop()
  if music ~= nil then
    music:stop()
  end
  music = nil
  musicIndex = nil
end

return sound