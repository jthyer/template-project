local bg = {}
local private = {}

local quads = {}
local canvas = love.graphics.newCanvas(640,480)
local dim = global.TILE_DIMENSION
local tileset

function bg.load(BGDATA)
  -- make it so you can change tilesets between levels later
  -- the tileset name is stored in the json export
  tileset = global.getAsset("tileset","labyrinth") 
  
  local image_width = tileset:getWidth()
  local image_height = tileset:getHeight()
  
  local rows = image_width / dim
  local cols = image_height / dim
  
  for i = 0, cols-1 do
    for j = 0, rows-1 do
      table.insert(quads,love.graphics.newQuad(
          j*dim, i*dim, dim, dim, image_width,image_height))
    end
  end 
  
  private.setCanvas(BGDATA)
end

function bg.draw()
  love.graphics.draw(canvas,0,0,0,1,1) 
end

function private.setCanvas(BGDATA)
  love.graphics.setCanvas(canvas)
  
  -- background color
  love.graphics.setColor(.35,.25,.25)
  love.graphics.rectangle("fill",0,0,
    global.WINDOW_WIDTH,global.WINDOW_HEIGHT)
  love.graphics.setColor(1,1,1)
  
  -- tiles
  for i,v in ipairs(BGDATA) do
    for j,v2 in ipairs(v) do
      if v2 ~= -1 then
        love.graphics.draw(tileset,quads[v2+1],(j-1)*dim,(i-1)*dim)
      end
    end
  end 
  
  love.graphics.setCanvas()
end

return bg