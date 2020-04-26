Paddle = Class{}

function Paddle:collides(target)
  -- Same logic as when the ball collides with paddle
  if self.x > target.x + target.width or target.x > self.x + self.width then
    return false
  end

  if self.y > target.y + target.height or target.y > self.y + self.height then
    return false
  end

  return true
end

function Paddle:init()

  -- The paddle width may change along the course of the game.
  self.width = 64

  -- The height should not change
  self.height = 16

  -- Default paddle is the medium one
  self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)

  -- Set the paddle above the screen by 32 pixels
  self.y = VIRTUAL_HEIGHT - 32

  -- There should be no movement along Y-axis
  self.dx = 0

  self.skin = 1
  self.size = 2

  self.speed = PADDLE_SPEED

end

function Paddle:update(dt)

  -- love.keyboard.isDown is used because the paddle may be moved continuously 
  -- The custom love.keyboard.wasPressed is used if the key is typed
  if love.keyboard.isDown('left') then
    self.dx = -self.speed
  elseif love.keyboard.isDown('right') then
    self.dx = self.speed
  else
    self.dx = 0
  end

  if self.dx < 0 then
    self.x = math.max(0, self.x + self.dx * dt)
  else
    self.x = math.min(VIRTUAL_WIDTH - self.width, self.x + self.dx * dt)
  end

end

function Paddle:render()
  love.graphics.draw(gTextures['main'],
    -- offset the quads by the value of skin.
    -- If skin is 1, then there is no offset becuase the multiplier will be 0.
    -- Otherwise, quads will be skipped by increments of four.
    gFrames['paddles'][self.size + 4 * (self.skin - 1)], self.x, self.y)
end