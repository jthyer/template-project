--[[
object.lua

Base definition of an object, in the Game Maker sense. An object exists
within a scene, and is completely destroyed whenever a scene is restarted
or reloaded. 

An object at its most simple is just an x and y coordinate, a hitbox, and
a class file that defines its behavior. If an object has a sprite, that sprite
is drawn at the x and y coordinate of the object every frame. An object can 
have "tags", like "solid" or "enemy" that other objects can check against.
Most objects will have step events, which run every frame.

Collision code is all handled here, including collision pertaining to solid 
objects. This is very important for making platformers, among other games.

Sprite animation will be handled here automatically, without the game-specific
code needing to worry about it.

I'll build out many other behaviors in here as needed for different games.

TODO:
- Refactor out hspeed and vspeed as default values. Let the movement code
  handle that, since its complicated.
- Fix instanceCreate, rename to remove "instance" gml terminology.
]]--

local objectParent = require "library.classic"
local object = objectParent:extend()

-- object constructor
-- runs sprite, tag, create constructors as needed
function object:new(id, class, x, y)
  self.id = id
  self.class = class
  self.x = x
  self.y = y
  self.hspeed = 0
  self.vspeed = 0
  self.flip_x = 1
  self.flip_y = 1
  self.rotation = 0
  
  if self.sprite then 
    self:sprite()
  else
    self.width = 16
    self.height = 16
    self.origin_x = self.width / 2
    self.origin_y = self.height / 2
  end

  if self.mask == nil then
    self:setMask(0,0,self.width,self.height)
  end
  
  if self.tag then 
    self:tag() 
  end
  
  if self.create then 
    self:create() 
  end
end

function object:update()
  if self.step then 
    self:step() 
  end

  if self.sprite and self.sprite.frameSpeed > 0 then
    if self.frameTimer > self.sprite.frameSpeed then
      self.frameIndex = self.frameIndex + 1
      if self.frameIndex > self.sprite.frameCount then
        self.frameIndex = 1
      end
      self.frameTimer = 0
    else
      self.frameTimer = self.frameTimer + 1
    end
  end
end

function object:draw()
  if self.visible ~= nil then
    love.graphics.draw(self.sprite.texture,self.sprite.frame[self.frameIndex],
      self.x+self.origin_x,self.y+self.origin_y,self.rotation,self.flip_x,self.flip_y,self.origin_x,self.origin_y) 
  else
    --debug
    --love.graphics.rectangle("line",self.x,self.y ,self.width,self.height)  
    --love.graphics.rectangle("line",self.x + self.mask.x ,self.y + self.mask.y ,self.mask.width,self.mask.height) 
  end
end

function object:setMask(x,y,w,h)
  self.mask = {}
  self.mask.x = x
  self.mask.y = y
  self.mask.width = w
  self.mask.height = h
end

function object:spriteSet(index)
  if self.sprite and self.spriteIndex ~= index then
    self.spriteIndex = index
    self.sprite = asset.sprite[self.spriteIndex]
    self.width = self.sprite.frameWidth
    self.height = self.sprite.frameHeight
    self.frameIndex = 1
    self.frameTimer = 0
    self.origin_x = self.width / 2
    self.origin_y = self.height / 2
    self.visible = true
  end
end

-- basic movement function for objects with no solid detection
function object:move()
  self.x = self.x + self.hspeed
  self.y = self.y + self.vspeed
end

-- basic collision function, returns object if colliding with object with given tag
-- x and y for checking relative positions
function object:checkCollision(tag, x, y, w, h)
  local x_offset, y_offset = 0, 0
  local widthOffset, heightOffset = 0, 0
  if x ~= nil then x_offset = x end
  if y ~= nil then y_offset = y end
  if w ~= nil then widthOffset = w end
  if h ~= nil then heightOffset = h end
  
  local function f(obj,tag)
    local collision = false
    
    local x, y = self.x + self.mask.x + x_offset, self.y + self.mask.y + y_offset
    local h, w = self.mask.height + heightOffset, self.mask.width + widthOffset
    local x2, y2 = obj.x + obj.mask.x, obj.y + obj.mask.y
    local h2, w2 = obj.mask.height, obj.mask.width    
    
    if (tag == nil or obj[tag] ~= nil) and (self.id ~= obj.id) then
      if (util.checkOverlap(x,y,w,h,x2,y2,w2,h2)) then
        collision = obj
      end
    end
    
    return collision
  end
      
  return manager.checkObjects(f,tag)
end

-- functions for moving around solid objects
function object:moveIfNoSolid()
  self:moveIfNoSolidHorizontal()
  self:moveIfNoSolidVertical()
end

function object:moveIfNoSolidHorizontal()
  local old_x, old_y = self.x, self.y
  
  self.x = self.x + self.hspeed
  
  local collide = self:checkCollision("solid")
  if (collide) then
    self.x = old_x
    self:moveToContactHor(collide)
  end
  
  return collide
end

function object:moveIfNoSolidVertical()
  local old_x, old_y = self.x, self.y
  
  self.y = self.y + self.vspeed
  
  local collide = self:checkCollision("solid")
  if (collide) then
    self.y = old_y
    self:moveToContactVert(collide)
  end    
  
  return collide
end
  
-- snap against side of given object horizontally
function object:moveToContactHor(obj)
  local pushback
  
  local x = self.x + self.mask.x
  local x2 = obj.x + obj.mask.x
  local w = self.mask.width
  local w2 = obj.mask.width
  
  if x < x2 then
    pushback = x + w - x2
    self.x = self.x - pushback
  elseif x2 < x then
    pushback = x2 + w2 - x
    self.x = self.x + pushback
  end
end

-- snap against side of given object horizontally
function object:moveToContactVert(obj)
  local pushback
  
  local y = self.y + self.mask.y
  local y2 = obj.y + obj.mask.y
  local h = self.mask.height
  local h2 = obj.mask.height
  
  if y < y2 then
    pushback = y + h - y2
    self.y = self.y - pushback
  elseif y2 < y then
    pushback = y2 + h2 - y
    self.y = self.y + pushback
  end
end

function object:setVector(angleStart, speed, rotate, offset)
  local angle = angleStart
  
  if offset then 
    angle = angle + offset
  end
  
  if rotate then
    self.rotation = angle + 1.571 -- rotate bullet
  end
  
  self.hspeed = speed * math.cos(angle)
  self.vspeed = speed * math.sin(angle)
end

function object:setVectorAimed(target_x,target_y, speed, rotate, offset)      
  local angle = math.atan2((target_y - self.y), (target_x - self.x))
  
  self:setVector(angle, speed, rotate, offset)
end

function object:instanceCreate(class,x,y)
  -- TO FIX 
  -- If an object calls this function in its creation code, they'll both have
  -- the same instance ID. Make a queue of objects to create and create them at the end.
  -- Make sure THOSE objects can create objects.
  
  return manager.addObject(class,x,y)
end

-- can target another ID, or the object can destroy itself
function object:instanceDestroy(targetID)
  local id = targetID or self.id

  return manager.removeObjectbyID(id)
end

return object