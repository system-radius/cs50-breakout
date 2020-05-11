Brick = Class{}

paletteColors = {
  [1] = {
    ['r'] = 99,
    ['g'] = 155,
    ['b'] = 255
  },
  [2] = {
    ['r'] = 106,
    ['g'] = 190,
    ['b'] = 47
  },
  [3] = {
    ['r'] = 217,
    ['g'] = 87,
    ['b'] = 99
  },
  [4] = {
    ['r'] = 215,
    ['g'] = 123,
    ['b'] = 186
  },
  [5] = {
    ['r'] = 251,
    ['g'] = 242,
    ['b'] = 54
  }
}

function Brick:init(x, y, locked)

  self.tier = 0
  self.color = 1
  
  -- This brick is either locked or not, defaults to not
  self.locked = locked or false

  -- For scoring purposes, to know that this brick was priorly locked.
  self.wasLocked = false
  self.hasKey = false

  self.x = x
  self.y = y
  self.width = 32
  self.height = 32

  self.inPlay = true

  self.pSystem = love.graphics.newParticleSystem(gTextures['particle'], 64)

  -- The life time of a spawned particle.
  -- A particle may last between 0.5 (min) to 1 (max) second
  self.pSystem:setParticleLifetime(0.5, 1)

  -- The value of accelerations for the particles
  self.pSystem:setLinearAcceleration(
    -15, -- The acceleration towards left.
    0,   -- Upward acceleration
    15,  -- Acceleration towards right.
    80   -- downward acceleration
  )

  self.pSystem:setAreaSpread('normal', 10, 10)

end

function Brick:hit(unlock)

  if self.locked then
    if unlock then
      self.locked = false
      self.wasLocked = true

      gSounds['select']:stop()
      gSounds['select']:play()
      return
    end

    gSounds['wall-hit']:stop()
    gSounds['wall-hit']:play()
    return
  end

  -- All subsequent hits after unlocking are normally scored
  self.wasLocked = false

  -- initialize the color for the particle system
  self.pSystem:setColors(
    paletteColors[self.color].r,
    paletteColors[self.color].g,
    paletteColors[self.color].b,
    55 * (self.tier + 1), -- Higher tiers have brighter particle colors
    paletteColors[self.color].r,
    paletteColors[self.color].g,
    paletteColors[self.color].b,
    0 -- But they will still fade back to 0.
  )
  self.pSystem:emit(64)
  
  gSounds['brick-hit-2']:stop()
  gSounds['brick-hit-2']:play()

  if self.tier > 0 then
    if self.color == 1 then
      self.tier = self.tier - 1
      self.color = 5
    else
      self.color = self.color - 1
    end
  else
    if self.color == 1 then
      self.inPlay = false
    else
      self.color = self.color - 1
    end
  end

  if not self.inPlay then
    gSounds['brick-hit-1']:stop()
    gSounds['brick-hit-1']:play()
  end

end

function Brick:update(dt)
  self.pSystem:update(dt)
end

function Brick:render()
  if not self.inPlay then
    return
  end

  if not self.locked then
    love.graphics.draw(gTextures['main'],
      -- Offset the color by fours.
      gFrames['bricks'][1 + ((self.color - 1) * 4) + self.tier], self.x, self.y)
  else
    love.graphics.draw(gTextures['main'],
      gFrames['locked'], self.x, self.y)
  end
end

function Brick:renderParticles()
  -- The particles are to be rendered if this brick is hit.
  love.graphics.draw(self.pSystem, self.x + 16, self.y + 8)
end