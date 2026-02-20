--[[
main.lua

Loads core engine, runs game loop, handles frame data, game quitting, fullscreen.
]]--

-- import core engine
window = require "core.window"
util = require "core.util"
object = require "core.object" 
manager = require "core.manager"
asset = require "core.asset"
scene = require "core.scene"
sound = require "core.sound"
background = require "core.background"
keyboard = require "core.keyboard"
text = require "core.text"

-- import game-specific info
info = require "source.info"
init = require "source.init"

-- define frame data
local FPS_TARGET = 60
local TICK_PERIOD = 1/FPS_TARGET
local accumulator = 0.0
local frameCount = 0
local dtCount = 0
local fps = 0
local debug = false
local frameCanvas = love.graphics.newCanvas(window.WINDOW_WIDTH,window.WINDOW_HEIGHT)
local changeFullscreen

-- load initial game state on launch
function love.load()
  math.randomseed(os.time())
  
  -- window settings
  love.graphics.setDefaultFilter("linear", "linear", 1)
  love.window.setTitle(info.gameTitle)
  love.window.setVSync( 1 )  
    
  text.setFont(info.defaultFont,info.defaultFontSize)
  
  scene.load(1)
end

-- updates every frame, caps fps
function love.update(dt)
  local delta = dt

  dtCount = dtCount + delta
  accumulator = accumulator + delta
  if accumulator >= TICK_PERIOD then
    scene.update()
    accumulator = accumulator - TICK_PERIOD
    
    frameCount = frameCount + 1

    if frameCount == FPS_TARGET then
      fps = math.floor((FPS_TARGET*100)/dtCount)/100
      frameCount = 0
      dtCount = 0
    end
  end  
end

-- draw step, runs after update step
-- draws to canvas first, then to the screen depending on window settings
function love.draw()
  love.graphics.setCanvas(frameCanvas)
  scene.draw()
  
  if debug then
    love.graphics.printf(fps,10,10, 200, "left")
    love.graphics.printf(manager.getObjectCount(),10,40, 200, "left")
  end
   
  love.graphics.setCanvas()
  
  local frameScale = math.min(
    window.current_width / window.WINDOW_WIDTH,
    window.current_height / window.WINDOW_HEIGHT
  )
  
  local frameX = (window.current_width - (window.WINDOW_WIDTH*frameScale)) / 2
  local frameY = (window.current_height - (window.WINDOW_HEIGHT*frameScale)) / 2
 
  love.graphics.draw(frameCanvas,frameX,frameY,0,frameScale,frameScale)
end

-- quit the game with escape, change fullscreen with f
-- TODO: make a proper pause screen/options menu
function love.keypressed(key, scancode)
  if key == "escape" then
    love.event.quit()
  elseif key == "r" then
    love.event.push("quit","restart")
  elseif key == "f" then
     changeFullscreen()
  elseif key == "pagedown" then
    scene.next()
  elseif key == "pageup" then
    scene.previous()
  end
end

function changeFullscreen() 
  local fullscreen = love.window.getFullscreen()
  
  love.window.setFullscreen(not fullscreen)
  if fullscreen then
    window.current_width, window.current_height = window.WINDOW_WIDTH,window.WINDOW_HEIGHT
  else
    window.current_width, window.current_height = love.graphics.getDimensions()
  end
end
