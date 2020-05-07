ServeState = Class{__includes = BaseState}

function ServeState:enter(params)

  self.highscores = params.highscores
  self.paddle = params.paddle
  self.bricks = params.bricks
  self.health = params.health
  self.score = params.score
  self.level = params.level
  self.keys = params.keys

  self.ball = Ball()
  self.ball.skin = math.random(7)
end

function ServeState:update(dt)

  self.paddle:update(dt)
  self.ball.x = self.paddle.x + (self.paddle.width / 2) - (self.ball.width / 2)
  self.ball.y = self.paddle.y - self.ball.height

  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    gStateMachine:change('play', {
      paddle = self.paddle,
      bricks = self.bricks,
      health = self.health,
      score = self.score,
      level = self.level,
      ball = self.ball,
      keys = self.keys,
      highscores = self.highscores
    })
  end

  if love.keyboard.wasPressed('escape') then
    love.event.quit()
  end

end

function ServeState:render()

  self.paddle:render()
  self.ball:render()

  for k, brick in pairs(self.bricks) do
    brick:render()
  end

  renderHealth(self.health)
  renderScore(self.score)

  love.graphics.setFont(gFonts['medium'])
  love.graphics.printf("Press Enter to serve", 0, 140, VIRTUAL_WIDTH, 'center')

end