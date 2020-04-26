Ball = Class{}

function Ball:init(skin, x, y)

  self.diameter = 8
  self.width = 8
  self.height = 8
  self.x = x or (VIRTUAL_WIDTH / 2) - (self.diameter / 2)
  self.y = y or VIRTUAL_HEIGHT - 41

  self.active = true

  self.skin = skin
end

function Ball:update(dt)

  if not self.active then
    return
  end

  local wallHit = false

  if self.x <= 0 then
    self.dx = -self.dx
    self.x = 0
    wallHit = true
  elseif self.x >= VIRTUAL_WIDTH - self.diameter then
    self.dx = -self.dx
    self.x = VIRTUAL_WIDTH - self.diameter
    wallHit = true
  end

  if self.dy < 0 and self.y <= 0 then
    self.dy = -self.dy
    self.y = 0
    wallHit = true
    -- There will be no clamping for when the ball touches the bottom of the screen
    -- as that is a death scenario
  end

  if wallHit then
    -- This just makes it so that if there is a need to update the sound used,
    -- It can be easily changed.
    gSounds['wall-hit']:play()
  end

  self.x = self.x + self.dx * dt
  self.y = self.y + self.dy * dt

end

function Ball:render()
  if not self.active then
    return
  end

  love.graphics.draw(gTextures['main'], gFrames['balls'][self.skin], self.x, self.y)
end

-- The ball can collide with many things
function Ball:collides(target)

  if self.x > target.x + target.width or target.x > self.x + self.width then
    return false
  end

  if self.y > target.y + target.height or target.y > self.y + self.height then
    return false
  end

  return true
end

function Ball:reset()

  self.x = (VIRTUAL_WIDTH / 2) - (self.diameter / 2)
  self.y = (VIRTUAL_HEIGHT / 2) - (self.diameter / 2)
  self.dx = 0
  self.dy = 0

end