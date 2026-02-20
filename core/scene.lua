--[[
scene.lua

A scene is basically a room from Game Maker. It reads tile and object data
from my editor's scene files in the "scenes" folder into a big table, loads
the background and object managers, runs the manager update function, and
draws everything to the screen. 
]]--

local scene = {}
local sceneData = require("core.sceneData")
local sceneNumber
local sceneTotal = #sceneData

function scene.load(i)
  sceneNumber = i
  
  text.screenClear()
  init.load(sceneNumber)
  keyboard.load()
  background.load(sceneData[sceneNumber])
  manager.load(sceneData[sceneNumber].objectData)
end

function scene.update()
  if text.screenUpdate() then
    return
  end
  
  manager.update()  
end

function scene.draw()
  background.draw()
  manager.draw()
  
  text.screenDraw()
end

-- TODO: track scenes with indexes for non-linear traversal
function scene.getSceneNumber()
  return sceneNumber
end

function scene.getSceneMax()
  return sceneTotal
end

function scene.next()
  if sceneNumber < sceneTotal then
    sceneNumber = sceneNumber + 1
  else
    return
  end
  
  -- kludge in case level skip keys break music
  if sceneNumber == 2 and not sound.musicIsPlaying() then
    sound.musicPlay("bgm_junior")
  end
  
  scene.load(sceneNumber)
end

function scene.previous()
  if sceneNumber > 1 then
    sceneNumber = sceneNumber - 1
  end
  
  -- kludge in case level skip keys break music
  if sceneNumber == 5 then
    sound.musicPlay("bgm_junior")
  end
  
  scene.load(sceneNumber)
end

function scene.restart()
  scene.load(sceneNumber)
end

return scene