--[[
manager.lua

The manager file handles all the objects for a given scene, and offers an
interface for objects to interact with other objects.

Objects are defined on a scene by scene basis. The object table is completely
emptied between scenes. 

All the implementation for the basic game world object is done in object.lua.
Specific object implementations are done in the source folder on a per-game
basis. The intent here is to mimic the basic functionality of a blank object
in Game Maker.
]]--

local manager = {}
local objectTable = {}
local objectToDestroy = {}
local instanceID 

local class = {}

-- iterate through classes folder, defining code for each class
local function defineClasses()
  local dir = "source/classes"
  local files = love.filesystem.getDirectoryItems(dir)
  
  for i, file in ipairs(files) do
    if string.sub(file, -4) == '.lua' then
      local classIndex = string.sub(file,1,string.len(file)-4)
      class[classIndex] = require("source.classes." .. classIndex)
    end
  end
end

defineClasses()

function manager.load(OBJECTDATA)
  objectTable = {}
  objectToDestroy = {}
  instanceID = 1
    
  for i,obj in ipairs(OBJECTDATA) do
    manager.addObject(obj.class,obj.x,obj.y)
  end
end

function manager.update()
  for i,obj in ipairs(objectTable) do
    obj:update()
  end 

  -- destroy all objects marked for death
  -- breaks and resets after removal, so table.remove skipping a loop iteration doesn't matter
  for i,id in ipairs(objectToDestroy) do
    for k,obj in ipairs(objectTable) do
      if obj.id == id then
        table.remove(objectTable,k)
        break
      end
    end
  end 
  objectToDestroy = {}
end

function manager.draw()
  for i,obj in ipairs(objectTable) do
    obj:draw()
  end 
end

function manager.addObject(classIndex,x,y)
  local obj = class[classIndex](instanceID,classIndex,x,y)
  table.insert(objectTable,obj)
  
  instanceID = instanceID + 1
    
  return obj
end

function manager.removeObjectbyID(id)
  table.insert(objectToDestroy,id)
end

function manager.getObjectByID(id)
  for i,obj in ipairs(objectTable) do
    if obj.id == id then
      return obj
    end
  end
  
  return nil
end

function manager.getObjectByTag(tag)
  for i,obj in ipairs(objectTable) do
    if obj[tag] then
      return obj
    end
  end
  
  return nil
end

function manager.checkObjects(f,arg)
  -- perform a passed function on all objects 
  -- immediately return true if any f(obj) returns true
  for i,obj in ipairs(objectTable) do
    if f(obj,arg) then
      return obj
    end
  end
  return nil
end  

function manager.getObjectCount()
  return #objectTable
end

return manager