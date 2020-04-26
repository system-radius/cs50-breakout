PowerUp = Class{}

--[[
  Bonuses:
  1 - decrease size (bad)
  2 - increase size (good)
  3 - extra life (good)
  4 - lose life (bad)
  5 - increase speed (good)
  6 - decrease speed (bad)
  7 - smaller ball (bad)
  8 - bigger ball (good)
  9 - additional balls (good)
  10 - key (good)
]]
function PowerUp:init(bonus, x, y)
  self.x = x
  self.y = y

  self.width = POWER_UP_SIZE
  self.height = POWER_UP_SIZE

  self.bonus = bonus

  self.applied = false

  self.dy = 50
end

function PowerUp:update(dt)
  self.y = self.y + self.dy * dt
end

function PowerUp:render()
  love.graphics.draw(gTextures['main'], gFrames['power-ups'][self.bonus], self.x, self.y)
end