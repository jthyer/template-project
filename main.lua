global = {}
global.WINDOW_WIDTH = 640
global.WINDOW_HEIGHT = 480
global.TILE_DIMENSION = 16

kb = require("source.kb")
util = require("source.util")

require("closure")

local asset = require("source.asset")
local scene = require("source.scene")

local tickPeriod = 1/60
local accumulator = 0.0

function love.load()
  love.graphics.setDefaultFilter("linear", "linear", 1)
  love.window.setTitle("Template Project")
  love.window.setVSync( 1 )  

  scene.load(1)
end

function love.update(dt)
  local delta = dt
  accumulator = accumulator + delta
  if accumulator >= tickPeriod then
    kb.update()
    scene.update()
    accumulator = accumulator - tickPeriod
  end  
  
  for i,v in ipairs(objects) do
    v.update()
  end
end

function love.draw()
  scene.draw()
  kb.draw()

  for i,v in ipairs(objects) do
    love.graphics.rectangle("fill",v.get_x(),v.get_y(),32,32)  
  end

end

function global.getAsset(assetType,index)
  return asset[assetType][index]
end

function love.keypressed(key, scancode)
   if key == "escape" then
      love.event.quit()
   end
end