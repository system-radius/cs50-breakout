PlayState = Class{__includes = BaseState}

function PlayState:enter(params)

  self.paddle = params.paddle
  self.bricks = params.bricks
  self.health = params.health
  self.score = params.score
  self.level = params.level
  self.ball = params.ball
  self.highscores = params.highscores

  self.keys = params.keys

  self.activeBalls = 1
  self.balls = {}

  table.insert(self.balls, self.ball)
  -- used for tracking power ups.
  self.powerUps = {}

  self.unlock = false

  self.paused = false

  self.ball.dx = math.random(-BALL_SPEED_X, BALL_SPEED_X)
  self.ball.dy = math.random(-BALL_SPEED_Y, -BALL_SPEED_Y - 10)
end

function PlayState:checkVictory()

  -- Find any instances of the bricks that are still in play.
  for k, brick in pairs(self.bricks) do
    if brick.inPlay then
      -- If one is found, then the game is not yet over.
      return false
    end
  end

  return true
end

--[[
    Check if the particular brick that was recently destroyed can generate a power up.
]]
function PlayState:canGeneratePowerUp()

  if self.level % 5 == 0 or self.level == 1 then
    -- If the current level is divisible by 5, treat it like a bonus level and allow
    -- all destroyed bricks to generate power ups.
    return true
  end
  -- Give a 25% chance for a brick to generate a power up.
  return math.random(4) == 1 and true or false
end

--[[
    The actual generation of power up. Simply randomize between the 10 power ups.
]]
function PlayState:generatePowerUp(brick)

  -- There are 10 power ups to choose from
  local bonus = math.random(10)
  local x = (brick.x + (brick.width / 2)) - (POWER_UP_SIZE / 2)
  local y = brick.y

  if bonus == 7 or bonus == 8 then
    -- It is quite hard to implement the differing size for the ball,
    -- so 7 (supposedly for smaller ball) and 8 (for larger ball) will generate
    -- additional balls power up instead.
    -- This also makes it so that the balls power up has a higher chance of spawning
    -- It breaks the game a little bit, but it is quite fun to watch and play. :)
    bonus = 9
  end

  return PowerUp(bonus, x, y)
end

--[[
    The actual application of the power ups. I don't know the implementation for the switch-case
    in Lua just yet, so please forgive this big if statement.
]]
function PlayState:applyPowerUp(powerUp)

  -- As the power-ups are quite random in their effect (there is no one particular
  -- aspect of the game it can change), it is better to implement their effects here.
  if powerUp == 1 then
    self.paddle.size = math.max(1, self.paddle.size - 1)
    self.paddle.width = self.paddle.size * 32
    gSounds['no-select']:stop()
    gSounds['confirm']:stop()
    gSounds['no-select']:play()
  elseif powerUp == 2 then
    self.paddle.size = math.min(4, self.paddle.size + 1)
    self.paddle.width = self.paddle.size * 32
    gSounds['no-select']:stop()
    gSounds['confirm']:stop()
    gSounds['confirm']:play()
  elseif powerUp == 3 then
    self.health = math.min(3, self.health + 1)
    gSounds['no-select']:stop()
    gSounds['confirm']:stop()
    gSounds['confirm']:play()
  elseif powerUp == 4 then
    self.health = self.health - 1
    gSounds['no-select']:stop()
    gSounds['confirm']:stop()
    gSounds['no-select']:play()
  elseif powerUp == 5 then
    self.paddle.speed = math.min(PADDLE_SPEED_MAX, self.paddle.speed + PADDLE_SPEED_INCREMENT)
    gSounds['no-select']:stop()
    gSounds['confirm']:stop()
    gSounds['confirm']:play()
  elseif powerUp == 6 then
    self.paddle.speed = math.max(PADDLE_SPEED_MIN, self.paddle.speed - PADDLE_SPEED_INCREMENT)
    gSounds['no-select']:stop()
    gSounds['confirm']:stop()
    gSounds['no-select']:play()
  elseif powerUp == 9 then
    gSounds['no-select']:stop()
    gSounds['confirm']:stop()
    gSounds['confirm']:play()
    self.activeBalls = self.activeBalls + 2
    local tempBall = self.balls[1]
    -- Spawn 2 more balls
    local newBall = Ball(math.random(7), tempBall.x, tempBall.y)
    newBall.dx = dx or math.random(-BALL_SPEED_X, BALL_SPEED_X)
    newBall.dy = dy or math.random(-BALL_SPEED_Y, -BALL_SPEED_Y - 10)
    table.insert(self.balls, newBall)
    
    newBall = Ball(math.random(7), tempBall.x, tempBall.y)
    newBall.dx = dx or math.random(-BALL_SPEED_X, BALL_SPEED_X)
    newBall.dy = dy or math.random(-BALL_SPEED_Y, -BALL_SPEED_Y - 10)
    table.insert(self.balls, newBall)
  else
    gSounds['no-select']:stop()
    gSounds['confirm']:stop()
    gSounds['confirm']:play()
    -- All other power-ups will allow for the key to activate
    self.keys = self.keys + 1
  end
end

--[[
  Update a particular ball from the balls table.
]]
function PlayState:updateBall(ball, dt)

  if not ball.active then
    return
  end

  ball:update(dt)

  if ball:collides(self.paddle) then
    ball.dy = -ball.dy
    ball.y = self.paddle.y - 8

    if ball.x < self.paddle.x + (self.paddle.width / 2) and self.paddle.dx < 0 then
      ball.dx = -50 - (8 * (self.paddle.x + self.paddle.width / 2 - ball.x))
    elseif ball.x > self.paddle.x + (self.paddle.width / 2) and self.paddle.dx > 0 then
      ball.dx = 50 + (8 * math.abs(self.paddle.x + self.paddle.width / 2 - ball.x)) 
    end

    gSounds['paddle-hit']:stop()
    gSounds['paddle-hit']:play()
  end

  for k, brick in pairs(self.bricks) do
    -- This loop is only for checking brick collisions
    if brick.inPlay and ball:collides(brick) then
      
      local addition = (brick.tier * 200 + brick.color * 25)

      if brick.locked and self.keys > 0 then
        brick:hit(true)
        addition = addition * 2
        self.keys = math.max(0, self.keys - 1)
      else
        brick:hit(false)
      end

      if not brick.inPlay and self:canGeneratePowerUp() then
        -- Calculate the chances of this brick generating power ups
        table.insert(self.powerUps, self:generatePowerUp(brick))
      end

      if not brick.locked then
        self.score = self.score + addition
      end

      -- Check for victory
      if self:checkVictory() then
        local tempBall = ball
        gSounds['victory']:play()
        gStateMachine:change('victory', {
          paddle = self.paddle,
          health = self.health,
          score = self.score,
          level = self.level,
          ball = tempBall,
          highscores = self.highscores,
          keys = self.keys
        })
      end

      -- left side collision
      if ball.x + 2 < brick.x and ball.dx > 0 then
        ball.dx = -ball.dx
        ball.x = brick.x - 8

      --right side collision
      elseif ball.x + 6 > brick.x + brick.width and ball.dx < 0 then
        ball.dx = -ball.dx
        ball.x = brick.x + brick.width

      -- top collision
      elseif ball.y < brick.y then
        ball.dy = -ball.dy
        ball.y = brick.y - 8

      -- bottom collision
      else
        ball.dy = -ball.dy
        ball.y = brick.y + brick.height
      end

      -- slightly scale the y velocity to speed up the game, capping at +- 150
      if math.abs(ball.dy) < 150 then
        ball.dy = ball.dy * 1.02
      end

      -- Break out of the loop since the ball has already hit something
      break
    end
  end

  if ball.y >= VIRTUAL_HEIGHT then
    ball.active = false
    self.activeBalls = self.activeBalls - 1
    if self.activeBalls == 0 then
      self.health = self.health - 1
      gSounds['hurt']:play()

      if self.health == 0 then
        gStateMachine:change('game-over', {
          score = self.score,
          highscores = self.highscores
        })
      else
        gStateMachine:change('serve', {
          paddle = self.paddle,
          bricks = self.bricks,
          health = self.health,
          score = self.score,
          level = self.level,
          highscores = self.highscores,
          keys = self.keys
        })
      end
    end
  end
  
end

--[[
  For each ball in the balls table, call the update on it.
  Also, attempt to remove the ball if it is not active anymore.
]]
function PlayState:updateBalls(dt)

  for i, ball in pairs(self.balls) do
    self:updateBall(ball, dt)
  end

  for i, ball in pairs(self.balls) do
    if not ball.active then
      table.remove(self.balls, i)
    end
  end

end

--[[
  Update the power ups, so that they descend slowly to the player.
  If their value have been applied, or they are below the screen,
  remove then.
]]
function PlayState:updatePowerUps(dt)

  for i, powerUp in pairs(self.powerUps) do
    powerUp:update(dt)
    if self.paddle:collides(powerUp) then
      self:applyPowerUp(powerUp.bonus)
      powerUp.applied = true
    end
  end

  for i, powerUp in pairs(self.powerUps) do
    -- Applied power ups removal
    if powerUp.applied or powerUp.y > VIRTUAL_HEIGHT then
      table.remove(self.powerUps, i)
    end
  end
end

--[[
  Update the particles for the bricks. Originally, the brick:hit()
  is supposed to be checked here. But that method is closely related
  to a ball instance, so it is better to check the hits in the ball
  update. That kind of setup also allows the balls to hit the bricks
  individually.
]]
function PlayState:updateBricks(dt)

  -- for rendering particle systems
  for k, brick in pairs(self.bricks) do
    brick:update(dt)
  end

end

function PlayState:update(dt)

  if love.keyboard.wasPressed('space') then
    self.paused = not self.paused
    gSounds['pause']:play()
  end

  -- if not self.served and (love.keyboard.wasPressed('enter')
  --   or love.keyboard.wasPressed('return')) then
  --   self.served = true
  -- end

  if self.paused then
    -- Don't do any updates if the game is paused
    return
  end

  self.paddle:update(dt)
  self:updateBalls(dt)
  self:updatePowerUps(dt)
  self:updateBricks(dt)

  if love.keyboard.wasPressed('escape') then
    love.event.quit()
  end

end

function PlayState:render()
  self.paddle:render()

  for i, ball in pairs(self.balls) do
    ball:render()
  end

  for k, brick in pairs(self.bricks) do
    brick:render()
  end

  for i, powerUp in pairs(self.powerUps) do
    powerUp:render()
  end

  -- This needs to be in another loop so as to not overlap the particles
  -- with other bricks. Also, the particles are not going to be rendered
  -- until the emit function is called for a particular system.
  for k, brick in pairs(self.bricks) do
    brick:renderParticles()
  end

  renderHealth(self.health)
  renderScore(self.score)

  -- Draw a key to signify that the player can now unlock blocks.
	love.graphics.draw(gTextures['main'], gFrames['power-ups'][10], VIRTUAL_WIDTH - 140, 3, 0, 0.7, 0.7)
	love.graphics.setFont(gFonts['small'])
	love.graphics.setColor(255, 255, 255, 255)		
	love.graphics.print('x' .. tostring(self.keys), VIRTUAL_WIDTH - 125, 4)

  if self.paused then
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
  end

end