GameOverState = Class{__includes = BaseState}

function GameOverState:enter(params)
  self.score = params.score

  self.highscores = params.highscores
  self.scoreIndex = 0

  self:findHighscore()
end

function GameOverState:update(dt)

  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    if self.scoreIndex > 0 then
      gStateMachine:change('enter', {
        score = self.score,
        highscores = self.highscores,
        scoreIndex = self.scoreIndex
      })
    else
      gStateMachine:change('start', {
        highscores = self.highscores
      })
    end
  end

  if love.keyboard.wasPressed('escape') then
    love.event.quit()
  end
end

function GameOverState:render()
  love.graphics.setFont(gFonts['large'])
  love.graphics.printf('GAME OVER', 0, VIRTUAL_HEIGHT / 3, VIRTUAL_WIDTH, 'center')

  love.graphics.setFont(gFonts['medium'])
  love.graphics.printf('Final Score: ' .. tostring(self.score),
    0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')

  if self.scoreIndex > 0 then
    love.graphics.printf('New Highscore! Press Enter to input your name!',
      0, VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT / 4), VIRTUAL_WIDTH, 'center')
  else 
    love.graphics.printf('Press enter!',
      0, VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT / 4), VIRTUAL_WIDTH, 'center')
  end

end

function GameOverState:findHighscore()

  for i, score in pairs(self.highscores) do
    if score.score < self.score then
      self.scoreIndex = i
      return true
    end
  end

end