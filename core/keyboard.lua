--[[
keyboard.lua

Love's keyboard commands don't give me access to all the information I want
for my games. I use this interface file to check for stuff like whether a 
key was released or pressed that frame. Plus it lets me put all my hard key
checks in one file. This way I can easily change them or add rebinding
down the line.

Todo:
- Generic key check and key pressed function instead of specific ones.
]]--

local keyboard = {}

local actionHeld = false
local shiftHeld = false

function keyboard.left()
  return love.keyboard.isDown("left") and 
    not love.keyboard.isDown("right")
end

function keyboard.right()
  return love.keyboard.isDown("right") and
   not love.keyboard.isDown("left")
end

function keyboard.up()
  return love.keyboard.isDown("up") and
   not love.keyboard.isDown("down")
end

function keyboard.down()
  return love.keyboard.isDown("down") and
   not love.keyboard.isDown("up")
end

function keyboard.shift()
  return love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift") 
end

function keyboard.shiftPressed()
  if keyboard.shift() then
    if shiftHeld == false then
      shiftHeld = true
      return true
    end
  else
    shiftHeld = false
  end
  return false
end

function keyboard.action()
  return love.keyboard.isDown("z")
end

function keyboard.actionPressed()
  if love.keyboard.isDown("z") then
    if actionHeld == false then
      actionHeld = true
      return true
    end
  else
    actionHeld = false
  end
  return false
end

function keyboard.load()
  if love.keyboard.isDown("z") then 
    actionHeld = true
  end
  if keyboard.shift() then
    shiftHeld = true
  end
end

return keyboard