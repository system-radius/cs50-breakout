EnterHighscoreState = Class{__includes = BaseState}

local chars = {
  [1] = 65,
  [2] = 65,
  [3] = 65
}

local highlightedChar = 1

function EnterHighscoreState:enter(params)
  self.highscores = params.highscores
  self.score = params.score
  self.scoreIndex = params.scoreIndex

  self.highlight = 1
  self.entered = false
end

function EnterHighscoreState:update(dt)

  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    -- update scores table
    local name = string.char(chars[1]) .. string.char(chars[2]) .. string.char(chars[3])

    -- go backwards through high scores table till this score, shifting scores
    for i = 10, self.scoreIndex, -1 do
      self.highscores[i + 1] = {
        name = self.highscores[i].name,
        score = self.highscores[i].score
      }
    end

    self.highscores[self.scoreIndex].name = name
    self.highscores[self.scoreIndex].score = self.score

    -- write scores to file
    local scoresStr = ''

    for i = 1, 10 do
      scoresStr = scoresStr .. self.highscores[i].name .. '\n'
      scoresStr = scoresStr .. tostring(self.highscores[i].score) .. '\n'
    end

    love.filesystem.write('breakout.lst', scoresStr)

    gStateMachine:change('highscore', {
      highscores = self.highscores
    })
  end

  -- scroll through character slots
  if love.keyboard.wasPressed('left') and self.highlight > 1 then
    self.highlight = self.highlight - 1
    gSounds['select']:play()
  elseif love.keyboard.wasPressed('right') and self.highlight < 3 then
    self.highlight = self.highlight + 1
    gSounds['select']:play()
  end

  -- scroll through characters
  if love.keyboard.wasPressed('up') then
    chars[self.highlight] = chars[self.highlight] + 1
    if chars[self.highlight] > 90 then
      chars[self.highlight] = 65
    end
  elseif love.keyboard.wasPressed('down') then
    chars[self.highlight] = chars[self.highlight] - 1
    if chars[self.highlight] < 65 then
      chars[self.highlight] = 90
    end
  end

end

function EnterHighscoreState:render()

  love.graphics.setFont(gFonts['medium'])
  love.graphics.printf('Enter name:', 0, 10, VIRTUAL_WIDTH, 'center')

  love.graphics.setFont(gFonts['large'])
  EnterHighscoreState.resetColor()
  if self.highlight == 1 then
    EnterHighscoreState.setHighlightColor()
  end

  love.graphics.print(string.char(chars[1]), VIRTUAL_WIDTH / 2 - 28, VIRTUAL_HEIGHT / 2)

  EnterHighscoreState.resetColor()
  if self.highlight == 2 then
    EnterHighscoreState.setHighlightColor()
  end

  love.graphics.print(string.char(chars[2]), VIRTUAL_WIDTH / 2 - 4, VIRTUAL_HEIGHT / 2)

  EnterHighscoreState.resetColor()
  if self.highlight == 3 then
    EnterHighscoreState.setHighlightColor()
  end

  love.graphics.print(string.char(chars[3]), VIRTUAL_WIDTH / 2 + 20, VIRTUAL_HEIGHT / 2)


end

function EnterHighscoreState.resetColor()
  love.graphics.setColor(255, 255, 255, 255)
end

function EnterHighscoreState.setHighlightColor()
  love.graphics.setColor(103, 255, 255, 255)
end