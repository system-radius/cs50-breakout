VictoryState = Class{__includes = BaseState}

function VictoryState:enter(params)

  self.paddle = params.paddle
  self.health = params.health
  self.score = params.score
  self.level = params.level
  self.ball = params.ball
  self.highscores = params.highscores

end

function VictoryState:update(dt)
  
  self.paddle:update(dt)

  self.ball.x = self.paddle.x + (self.paddle.width / 2) - (self.ball.diameter / 2)
  self.ball.y = self.paddle.y - self.ball.diameter

  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    gStateMachine:change('serve', {
      paddle = self.paddle,
      health = self.health,
      bricks = LevelMaker.createMap(self.level + 1),
      score = self.score,
      level = self.level + 1,
      highscores = self.highscores
    })

  end

  if love.keyboard.wasPressed('escape') then
    love.event.quit()
  end
  
end

function VictoryState:render()
  self.paddle:render()
  self.ball:render()

  renderHealth(self.health)
  renderScore(self.score)

  love.graphics.setFont(gFonts['large'])
  love.graphics.printf('Level ' .. tostring(self.level) .. ' complete!',
    0, VIRTUAL_HEIGHT / 4, VIRTUAL_WIDTH, 'center')

  love.graphics.setFont(gFonts['medium'])
  love.graphics.printf('Press enter to go to the next level!',
    0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')
end