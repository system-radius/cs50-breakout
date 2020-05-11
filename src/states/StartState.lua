StartState = Class{__includes = BaseState}

local highlighted = 1

function StartState:enter(params)
  self.highscores = params.highscores
  
  self.minHighlight = 1
  highlighted = self.minHighlight
  self.optionCount = 3
  
  self.nextStates = {
    [1] = {
      state = 'paddle-select',
      params = {
        highscores = self.highscores
      },
      display = 'START',
      y = VIRTUAL_HEIGHT / 2 + 50
    },
    [2] = {
      state = 'highscore',
      params = {
        highscores = self.highscores
      },
      display = 'HIGH SCORE',
      y = VIRTUAL_HEIGHT / 2 + 70
    }
  
  }
end

function StartState:update(dt)

  if love.keyboard.wasPressed('up') then
    highlighted = math.max(highlighted - 1, self.minHighlight) 
    gSounds['paddle-hit']:stop()
    gSounds['paddle-hit']:play()
  elseif love.keyboard.wasPressed('down') then
    highlighted = math.min(highlighted + 1, self.optionCount) 
    gSounds['paddle-hit']:stop()
    gSounds['paddle-hit']:play()
  end

  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    gSounds['confirm']:play()
    gStateMachine:change(self.nextStates[highlighted].state, self.nextStates[highlighted].params)
  end

  if love.keyboard.wasPressed('escape') then
    love.event.quit()
  end

end

function StartState:render()
  
  love.graphics.setFont(gFonts['large'])
  love.graphics.printf('BREAKOUT', 0, VIRTUAL_HEIGHT / 3,
    VIRTUAL_WIDTH, 'center')

  love.graphics.setFont(gFonts['medium'])

  for i, option in pairs(self.nextStates) do

    love.graphics.setColor(255, 255, 255, 255)
    if highlighted == i then
      love.graphics.setColor(103, 255, 255, 255)
    end

    if i >= self.minHighlight then
      love.graphics.printf(option.display, 0, option.y, VIRTUAL_WIDTH, 'center')
    end
  end

  love.graphics.setColor(255, 255, 255, 255)
end