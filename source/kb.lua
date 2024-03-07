-- Love's keyboard commands don't give me access to all the information I want
-- for my games. I use this interface file to check for stuff like whether a 
-- key was released or pressed that frame, plus it lets me put all my hard key
-- checks in one file. This way I can easily change them or add rebinding
-- down the line.

local kb = {}

local jumpHeld = false
local jumpPressed = false

function kb.left()
  return love.keyboard.isDown("left") and 
    not love.keyboard.isDown("right")
end

function kb.right()
  return love.keyboard.isDown("right") and
   not love.keyboard.isDown("left")
end

function kb.jumpPressed()
  return jumpPressed
end

function kb.jumpHeld()
  return jumpHeld
end

function kb.update()
  if love.keyboard.isDown('z') or love.keyboard.isDown("up") then
    if jumpHeld == false then
      jumpPressed = true
    else
      jumpPressed = false
    end
  end
  
  jumpHeld = love.keyboard.isDown('z') or love.keyboard.isDown("up")
end

function kb.draw()
  -- for debug purposes only
  -- if jumpHeld then
    --love.graphics.printf("Jump held!", 32, 32,300,"left")
  -- end
end

return kb