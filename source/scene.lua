local scene = {}
local sceneData = require("source.sceneData")
local bg = require("source.bg")
local object = require("source.object")

function scene.load(s)
  bg.load(sceneData[s].tileData)
  object.load(sceneData[s].objectData)
end

function scene.update()
  object.update()
end

function scene.draw()
  bg.draw()
  object.draw()
end

return scene