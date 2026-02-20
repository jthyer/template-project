local player = object:extend()

local SPEED = 3
local JUMP = 6
local GRAVITY = 0.2
local FASTFALL = 10
local SLOWFALL = 5
local TIME_TO_RELEASE = 4
local JUMP_OFF_ENEMY = 1

function player:sprite()
  self:spriteSet("player")
  self:enemyMask()
end

function player:enemyMask()
  self:setMask(12,12,8,20)
end

function player:solidMask()
  self:setMask(8,4,16,28)
end

function player:tag()
  self.player = true
end

function player:create()
  self.jumpRelease = false
  self.jumpTimer = 0
  self.maxFallSpeed = FASTFALL
  self.grounded = true
end

function player:step()  
  self:solidMask()
  self:horizontalMovement()
  self:verticalMovement()
  self:enemyMask()
  self:checkEnemyCollision()
  self:spriteUpdate()
  self:levelCompleted()
end

function player:horizontalMovement()
  local old_x = self.x
  local old_y = self.y
  
  self.hspeed = 0

  if keyboard.left() then 
    self.hspeed = -SPEED
  elseif keyboard.right() then
    self.hspeed = SPEED
  end
    
  self:moveIfNoSolidHorizontal()
end

function player:verticalMovement()
  self.grounded = self:checkCollision("solid",0,1)
            
  if self.grounded then
    if keyboard.actionPressed() then
      sound.play("sfx_jump")
      self.vspeed = -JUMP
      self.jumpRelease = false
      self.jumpTimer = TIME_TO_RELEASE
    end
  else  
    self.maxFallSpeed = SLOWFALL
    if (not keyboard.action()) or
      (self.jumpRelease and self.vspeed < 0) then 
      self.jumpRelease = true
      if self.jumpTimer > 0 then 
        self.jumpTimer = self.jumpTimer - 1
      else
        if self.vspeed < -GRAVITY then
          self.vspeed = self.vspeed + GRAVITY
        end
        self.maxFallSpeed = FASTFALL
        self.vspeed = self.vspeed + (GRAVITY / 2)
      end
    end
    self.vspeed = self.vspeed + GRAVITY
    if self.vspeed > self.maxFallSpeed then
      self.vspeed = self.maxFallSpeed
    end
  end  
  
  local move = self:moveIfNoSolidVertical()
  if move and (self.y < move.y) then
    -- set vspeed to 0 on contact with ground
    self.vspeed = 0
  end
end

function player:spriteUpdate()
  if self.hspeed < 0 then
    self.flip_x = -1
  elseif self.hspeed > 0 then
    self.flip_x = 1
  end
  
  local sprite = self.spriteIndex  
  if not self.grounded then
    if keyboard.action() and not self.jumpRelease and self.vspeed > -5 then
      sprite = "playerJump"
    else
      sprite = "playerFall"
    end
  elseif self.hspeed ~= 0 then
    sprite = "playerWalk"
  else
    sprite = "player"
  end
  
  self:spriteSet(sprite)
end

function player:checkEnemyCollision()
  local bounce = self:checkCollision("enemy",-8,0,16,0)
  local enemy = self:checkCollision("enemy")
  local spike 
  
  if bounce then spike = bounce.spike end
  
  if (self.vspeed > 0 and bounce and not spike) then
    bounce:die()
    self.vspeed = -JUMP - JUMP_OFF_ENEMY
    self.jumpTimer = TIME_TO_RELEASE
  
    if keyboard.action() then
      self.jumpRelease = false
    end
  elseif enemy then
    self:die()
  end

  if self.y > window.WINDOW_HEIGHT then self:die() end
end

function player:die()
  sound.play("sfx_playerDead")
  self:instanceDestroy()
  scene.restart()
end

function player:levelCompleted()
  if self.y < -16 or self:checkCollision("win") then
    scene.next()
  end
end

return player