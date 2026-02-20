--[[
asset.lua

Define all the games' audiovisual assets in a way lua can interpret.
This file doesn't return functions for the other files to use like 
the others. Instead it's one big table of assets. These assets aren't
locked in any way, but they should be treated as constants.

There's definitely a way to do this in one simpler function, but I 
don't care enough to figure it out right now.
]]--

local asset = {}

asset.sprite = {}
asset.sound = {}
asset.bg = {}
asset.tileset = {}
asset.font = {}

local function defineSprites()
  local dir = "assets/sprites"
  local files = love.filesystem.getDirectoryItems(dir)
  
  for i, file in ipairs(files) do
    if string.sub(file, -4) == '.png' then
      local metadata = util.splitString(util.splitString(file,".")[1],"_")
      local index = metadata[2] 
      local frameCount = metadata[3]
      local frameSpeed = metadata[4]
      local filePath = dir .. "/" .. file
        
      asset.sprite[index] = {}
      asset.sprite[index].frame = {}
      local sprite = asset.sprite[index]
      
      sprite.texture = love.graphics.newImage(filePath)
      sprite.textureWidth = sprite.texture:getWidth()
      sprite.textureHeight = sprite.texture:getHeight()
      sprite.frameCount = tonumber(frameCount)
      sprite.frameSpeed = tonumber(frameSpeed)
      sprite.frameWidth = sprite.textureWidth / sprite.frameCount
      sprite.frameHeight = sprite.textureHeight
      
      for i = 1, sprite.frameCount do
        sprite.frame[i] = love.graphics.newQuad(sprite.frameWidth*(i-1), 0,
          sprite.frameWidth, sprite.frameHeight, sprite.textureWidth, sprite.textureHeight)
      end
    end
  end
end

local function defineSounds()
  local dir = "assets/sounds"
  local files = love.filesystem.getDirectoryItems(dir)
  
  for i, file in ipairs(files) do
    local index = string.sub(file,1,string.len(file)-4)
    local filePath = dir .. "/" .. file
    local extension = string.sub(file, -4)
    if extension == '.wav' then
      asset.sound[index] = love.audio.newSource(filePath,"static")
    elseif extension == '.ogg' or extension == '.mp3' then
      asset.sound[index] = love.audio.newSource(filePath,"stream")
    end
  end
end

local function defineBackgrounds()
  local dir = "assets/backgrounds"
  local files = love.filesystem.getDirectoryItems(dir)
  
  for i, file in ipairs(files) do
    if string.sub(file, -4) == '.png' then
      local index = string.sub(file,1,string.len(file)-4)
      local filePath = dir .. "/" .. file
      asset.bg[index] = love.graphics.newImage(filePath)
    end
  end
end

local function defineTilesets()
  local dir = "assets/tiles"
  local files = love.filesystem.getDirectoryItems(dir)
  
  for i, file in ipairs(files) do
    if string.sub(file, -4) == '.png' then
      local index = string.sub(file,1,string.len(file)-4)
      local filePath = dir .. "/" .. file
      asset.tileset[index] = love.graphics.newImage(filePath)
    end
  end 
end

local function defineFonts()
  local dir = "assets/fonts"
  local files = love.filesystem.getDirectoryItems(dir)
  
  for i, file in ipairs(files) do
    if string.sub(file, -4) == '.ttf' or string.sub(file, -4) == '.otf' then
      local index = string.sub(file,1,string.len(file)-4)
      local filePath = dir .. "/" .. file
      asset.font[index] = filePath 
        -- only defining the path here so text.lua can make different sized fonts
    end
  end  
end

defineSprites()
defineSounds()
defineBackgrounds()
defineTilesets()
defineFonts()

return asset