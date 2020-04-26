
function GenerateQuads(atlas, tileWidth, tileHeight)
  local sheetWidth = atlas:getWidth() / tileWidth
  local sheetHeight = atlas:getHeight() / tileHeight

  local sheetCounter = 1
  local spritesheet = {}

  for y = 0, sheetHeight - 1 do
    for x = 0, sheetWidth - 1 do
      spritesheet[sheetCounter] = 
        love.graphics.newQuad(x * tileWidth, y * tileHeight,
          tileWidth, tileHeight, atlas:getDimensions())
      sheetCounter = sheetCounter + 1
    end
  end

  return spritesheet
end

function table.slice(tbl, first, last, step)
  local sliced = {}

  -- i is initailized as either the given value for first or 1
  -- Then the loop is run until the value for last or the size of table
  -- Each run is incremented with the step value, or 1.
  for i = first or 1, last or #tbl, step or 1 do
    sliced[#sliced+1] = tbl[i]
  end

  return sliced
end

function GeneratePaddleQuads(atlas)

  local x = 0
  local y = 64

  local counter = 1
  local quads = {}

  for i = 0, 3 do

    -- Computation for the small paddle
    quads[counter] = love.graphics.newQuad(x, y, 32, 16, atlas:getDimensions())
    counter = counter + 1

    -- Computation for the medium paddle
    quads[counter] = love.graphics.newQuad(x + 32, y, 64, 16, atlas:getDimensions())
    counter = counter + 1

    -- Computation for the large paddle
    quads[counter] = love.graphics.newQuad(x + 96, y, 96, 16, atlas:getDimensions())
    counter = counter + 1

    -- Computation for the largest paddle
    quads[counter] = love.graphics.newQuad(x, y + 16, 128, 16, atlas:getDimensions())
    counter = counter + 1

    x = 0
    y = y + 32

  end

  return quads
end

function GenerateBallQuads(atlas)
  local x = 96
  local y = 48

  local counter = 1
  local quads = {}

  for i = 0, 3 do
    quads[counter] = love.graphics.newQuad(x, y, 8, 8, atlas:getDimensions())
    x = x + 8
    counter = counter + 1
  end

  x = 96
  y = 56

  for i = 0, 2 do
    quads[counter] = love.graphics.newQuad(x, y, 8, 8, atlas:getDimensions())
    x = x + 8
    counter = counter + 1
  end  

  return quads
end

function GenerateBrickQuads(atlas)
  return table.slice(GenerateQuads(atlas, 32, 16), 1, 21)
end

function GeneratePowerUpQuads(atlas)
  local x = 0
  local y = 192

  local quads = {}
  local counter = 1
  for i = 0, 10 do
    quads[counter] = love.graphics.newQuad(x + (i * 16), y, 16, 16, atlas:getDimensions())
    counter = counter + 1
  end

  return quads
end