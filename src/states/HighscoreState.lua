HighscoreState = Class{__includes = BaseState}

function HighscoreState:enter(params)
  self.highScores = params.highscores
end

function HighscoreState:update(dt)

  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return')
    or love.keyboard.wasPressed('escape') then
    gStateMachine:change('start', {
      highscores = self.highScores
    })
  end

end

--[[
function HighscoreState:render()
  
  love.graphics.setFont(gFonts['large'])
  love.graphics.printf('HIGH SCORES', 0, 3, VIRTUAL_WIDTH, 'center')

  love.graphics.setFont(gFonts['medium'])

  local y = 1
  local spacing = 20
  for i, score in pairs(self.scores) do

    love.graphics.print(tostring(i) .. '.', VIRTUAL_WIDTH / 4, (i + y) * spacing)

    love.graphics.print(score.name, VIRTUAL_WIDTH / 4 + spacing, (i + y) * spacing)
    love.graphics.printf(tostring(score.score),
      VIRTUAL_WIDTH / 2, (i + y) * spacing, VIRTUAL_WIDTH / 4, 'right')

  end

  love.graphics.setFont(gFonts['small'])
  love.graphics.printf('Press Enter/Escape go back to start.',
    0, VIRTUAL_HEIGHT - 10, VIRTUAL_WIDTH, 'center')

end 

]]

function HighscoreState:render()
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('High Scores', 0, 20, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['medium'])

    -- iterate over all high score indices in our high scores table
    for i = 1, 10 do
        local name = self.highScores[i].name or '---'
        local score = self.highScores[i].score or '---'

        -- score number (1-10)
        love.graphics.printf(tostring(i) .. '.', VIRTUAL_WIDTH / 4, 
            60 + i * 13, 50, 'left')

        -- score name
        love.graphics.printf(name, VIRTUAL_WIDTH / 4 + 38, 
            60 + i * 13, 50, 'right')
        
        -- score itself
        love.graphics.printf(tostring(score), VIRTUAL_WIDTH / 2,
            60 + i * 13, 100, 'right')
    end

    love.graphics.setFont(gFonts['small'])
    love.graphics.printf("Press Escape to return to the main menu!",
        0, VIRTUAL_HEIGHT - 18, VIRTUAL_WIDTH, 'center')
end
