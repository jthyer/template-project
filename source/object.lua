local object = {}

local objectTable = {}
local objectDeathFlag = {}
local private = {}
local itrID

local class = {}
class.jellyfishStill = require("source.class.jellyfishStill")
class.jellyfishMove = require("source.class.jellyfishMove")
class.wall = require("source.class.wall")
class.lilly = require("source.class.lilly")

function object.load(OBJECTDATA)
  itrID = 0
  objectTable = {}
  for i,obj in ipairs(OBJECTDATA) do
    table.insert(objectTable,private.createObject(obj.class,obj.x,obj.y))
  end
end

function object.update()
  for i,obj in ipairs(objectTable) do
    class[obj.class].update(obj,private)
  end 
end

function object.draw()
  for i,obj in ipairs(objectTable) do
    if obj.visible then
      love.graphics.draw(obj.sprite,obj.x,obj.y)
    else
      -- for debugging
      --love.graphics.rectangle("fill",obj.x,obj.y,16,16)
    end
  end
end

function private.createObject(c,x,y)
  local obj = {}
  obj.id = private.getID()
  obj.class = c
  obj.x, obj.y = x, y
  obj.width, obj.height = 16, 16
  obj.visible = true
  class[obj.class].load(obj)
  return obj
end

function private.checkCollisionWalls(x,y,w,h)
  -- iterates through object array checking for collision
  -- against any walls
  for i,obj in ipairs(objectTable) do
    if obj.class == "wall" and util.checkOverlap(x,y,w,h,
        obj.x,obj.y,obj.width,obj.height) then
      return true
    end
  end
  
  return false
end

function private.getID()
  local returnID = itrID
  itrID = itrID + 1
  
  return returnID
end

return object