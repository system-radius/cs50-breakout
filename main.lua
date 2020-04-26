-- Provide a single requirement.
require 'src/Dependencies'

function love.load()
  
  love.graphics.setDefaultFilter('nearest', 'nearest')
  math.randomseed(os.time())

  love.window.setTitle('Breakout')

  -- Load the fonts
  gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 32)
  }
  love.graphics.setFont(gFonts['small'])

  -- Load the textures
  gTextures = {
    ['background'] = love.graphics.newImage('graphics/background.png'),
    ['main'] = love.graphics.newImage('graphics/breakout.png'),
    ['arrows'] = love.graphics.newImage('graphics/arrows.png'),
    ['hearts'] = love.graphics.newImage('graphics/hearts.png'),
    ['particle'] = love.graphics.newImage('graphics/particle.png')
  }

  -- Load the quad frames / sprites from the textures
  gFrames = {
    ['arrows'] = GenerateQuads(gTextures['arrows'], 24, 24),
    ['paddles'] = GeneratePaddleQuads(gTextures['main']),
    ['balls'] = GenerateBallQuads(gTextures['main']),
    ['bricks'] = GenerateBrickQuads(gTextures['main']),
    ['hearts'] = GenerateQuads(gTextures['hearts'], 10, 9),
    ['power-ups'] = GeneratePowerUpQuads(gTextures['main']),
    ['locked'] = love.graphics.newQuad(160, 48, 32, 16, gTextures['main']:getDimensions())
  }

  -- Setup the virtual world
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    vsync = true,
    fullscreen = false,
    resizable = true
  })

  -- Load the sounds
  gSounds = {
    ['paddle-hit'] = love.audio.newSource('sounds/paddle_hit.wav'),
    ['score'] = love.audio.newSource('sounds/score.wav'),
    ['wall-hit'] = love.audio.newSource('sounds/wall_hit.wav'),
    ['confirm'] = love.audio.newSource('sounds/confirm.wav'),
    ['select'] = love.audio.newSource('sounds/select.wav'),
    ['no-select'] = love.audio.newSource('sounds/no-select.wav'),
    ['brick-hit-1'] = love.audio.newSource('sounds/brick-hit-1.wav'),
    ['brick-hit-2'] = love.audio.newSource('sounds/brick-hit-2.wav'),
    ['hurt'] = love.audio.newSource('sounds/hurt.wav'),
    ['victory'] = love.audio.newSource('sounds/victory.wav'),
    ['recover'] = love.audio.newSource('sounds/recover.wav'),
    ['high-score'] = love.audio.newSource('sounds/high_score.wav'),
    ['pause'] = love.audio.newSource('sounds/pause.wav'),

    ['music'] = love.audio.newSource('sounds/music.wav')
  }

  -- Load the states
  gStateMachine = StateMachine {
    ['start'] = function() return StartState() end,
    ['play'] = function() return PlayState() end,
    ['serve'] = function() return ServeState() end,
    ['game-over'] = function() return GameOverState() end,
    ['victory'] = function() return VictoryState() end,
    ['highscore'] = function() return HighscoreState() end,
    ['enter'] = function() return EnterHighscoreState() end,
    ['paddle-select'] = function() return PaddleSelectState() end
  }
  gStateMachine:change('start', {
    highscores = loadHighscores()
  })

  gSounds['music']:play()
  gSounds['music']:setLooping(true)
  love.keyboard.keysPressed = {}

end

function love.resize(w, h)
  push:resize(w, h)
end

function love.update(dt)
  
  gStateMachine:update(dt)

  love.keyboard.keysPressed = {}
end

function love.keypressed(key)
  love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
  return love.keyboard.keysPressed[key]
end

function love.draw()
  push:start()

  local bgWidth = gTextures['background']:getWidth()
  local bgHeight = gTextures['background']:getHeight()

  love.graphics.draw(gTextures['background'],
    0, 0, -- Coodinates for the start of drawing
    0,    -- No rotation
    VIRTUAL_WIDTH / (bgWidth - 1), -- scale on X-axis
    VIRTUAL_HEIGHT / (bgHeight - 1) -- scale on Y-axis
    )

  gStateMachine:render()

  displayFPS()

  push:finish()
end

function displayFPS()

  love.graphics.setFont(gFonts['small'])
  love.graphics.setColor(0, 255, 0, 255)
  love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 5, 5)

end

function renderHealth(health)
  local healthX = VIRTUAL_WIDTH - 100

  for i = 1, health do
    love.graphics.draw(gTextures['hearts'], gFrames['hearts'][1], healthX, 5)
    healthX = healthX + 11
  end

  for i = 1, 3 - health do
    love.graphics.draw(gTextures['hearts'], gFrames['hearts'][2], healthX, 5)
    healthX = healthX + 11
  end
end

function renderScore(score)
  love.graphics.setFont(gFonts['small'])
  love.graphics.print('Score: ', VIRTUAL_WIDTH - 60, 5)
  love.graphics.printf(tostring(score), VIRTUAL_WIDTH - 50, 5, 40, 'right')
end

function loadHighscores()
  
  love.filesystem.setIdentity('breakout')

  if not love.filesystem.exists('breakout.lst') then
    local scores = ''
    for i = 10, 1, -1 do
      scores = scores .. 'AAA\n'
      scores = scores .. tostring(i * 100) .. '\n'
    end

    love.filesystem.write('breakout.lst', scores)
  end

  local name = true
  local currentName = nil
  local counter = 1

  local scores = {}

  -- Initialize the table for scores to be loaded
  for i = 1, 10 do
    scores[i] = {
      name = nil,
      score = nil
    }
  end

  for line in love.filesystem.lines('breakout.lst') do
    if name then
      scores[counter].name = string.sub(line, 1, 3) -- Get the substring starting at 1 up to the 3rd char.
    else
      scores[counter].score = tonumber(line)
      counter = counter + 1
    end

    -- Flip the name flag
    name = not name
  end

  return scores
end

function saveHighscores(highscores)
  love.filesystem.setIdentity('breakout')

  local scores = ''
  for i = 10, 1, -1 do
    scores = scores .. highscores[i].name .. '\n'
    scores = scores .. tostring(highscores[i].score) .. '\n'
  end

  love.filesystem.write('breakout.lst', scores)

end