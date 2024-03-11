local object = {}

local objectTable = {}
local objectDeathFlag = {}
local itrID

local new = {}
new.jellyfishStill = require("source.class.jellyfishStill")
new.jellyfishMove = require("source.class.jellyfishMove")
new.wall = require("source.class.wall")
new.player = require("source.class.player")

local function checkObjects(f)
  -- perform a passed function on all objects 
  -- immediately return true if any f(obj) returns true
  for i,obj in ipairs(objectTable) do
    if f(obj) then
      return true
    end
  end
  return false
end

local function getID()
  local returnID = itrID
  itrID = itrID + 1
  
  return returnID
end

local function newObject(c,x,y)
  local obj = {}
  obj = new[c](x,y,checkObjects)
  return obj
end

function object.load(OBJECTDATA)
  itrID = 0
  objectTable = {}
  for i,obj in ipairs(OBJECTDATA) do
    table.insert(objectTable,newObject(obj.class,obj.x,obj.y))
  end
end

function object.update()
  for i,obj in ipairs(objectTable) do
    if obj.update ~= nil then
      obj.update()
    end
  end 
end

function object.draw()
  for i,obj in ipairs(objectTable) do
    if obj.getSprite ~= nil then
      love.graphics.draw(obj.getSprite(),obj.get_x(),obj.get_y())
    else
      --for debugging
      love.graphics.rectangle("fill",obj.get_x(),obj.get_y(),16,16)
    end
  end
end

return object