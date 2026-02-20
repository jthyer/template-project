--[[
background.lua

Draw the background canvas for every scene. This includes two parts:
1) The background texture, an image which loops until it covers the screen.
2) The tiles for a specific scene.

Later, I want to have multiple layers of background textures, and I want them
to be able to scroll in parallax.
]]--
 
local background = {}

local quads = {}
local canvas
local dim = window.TILE_DIMENSION
local tileset
local texture
local textureIndex
local x, y 
local setCanvas, drawColor, drawTexture, drawTiles

function background.load(BGDATA)
  tileset = asset.tileset[BGDATA.tileset]
  
  local image_width = tileset:getWidth()
  local image_height = tileset:getHeight()
  
  local rows = image_width / dim
  local cols = image_height / dim
  
  x, y = 0, 0
  
  for i = 0, cols-1 do
    for j = 0, rows-1 do
      table.insert(quads,love.graphics.newQuad(
        j*dim, i*dim, dim, dim, image_width,image_height))
    end
  end 
  
  if not textureIndex then 
    textureIndex = init.backgroundTexture()
  end
  texture = asset.bg[textureIndex]
  
  setCanvas(BGDATA)
end

function background.setTexture(t)
  textureIndex = t
end

function background.draw()
  love.graphics.draw(canvas,0,0)
end
 
function setCanvas(BGDATA)
  canvas = love.graphics.newCanvas(BGDATA.width,BGDATA.height)
  love.graphics.setCanvas(canvas)
  
  drawColor(BGDATA)  
  drawTexture(BGDATA)
  drawTiles(BGDATA)

  love.graphics.setCanvas()
end

function drawColor(BGDATA)
  -- draw default color in case no texture is present
  local r, g, b = init.backgroundColor()
  love.graphics.setColor(r,g,b,1)
  love.graphics.rectangle("fill",0,0,BGDATA.width,BGDATA.height)
  love.graphics.setColor(1,1,1,1)
end

function drawTexture(BGDATA)
  -- loop texture until it covers the whole background
  if texture == nil then
    return
  end  
  
  local textureWidth = texture:getWidth()
  local textureHeight = texture:getHeight()
  local numHor = math.ceil(BGDATA.width / textureWidth)
  local numVert = math.ceil(BGDATA.height / textureHeight)
  
  for i=1,numHor do
    for j=1,numVert do
      love.graphics.draw(texture,(i-1)*textureWidth,(j-1)*textureHeight)
    end
  end
end

function drawTiles(BGDATA)
  -- draw tiles
  for i,v in ipairs(BGDATA.tileData) do
    for j,v2 in ipairs(v) do
      if v2 ~= -1 then
        love.graphics.draw(tileset,quads[v2+1],(j-1)*dim,(i-1)*dim)
      end
    end
  end 
end

return background