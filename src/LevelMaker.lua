LevelMaker = Class{}

NONE = 1
SINGLE_PYRAMID = 2
MULTI_PYRAMID = 3

SOLID = 1
ALTERNATE = 2
SKIP = 3
NONE = 4

function LevelMaker.createMap(level)

  local bricks = {}

  local numRows = math.random(5)
  local numCols = math.random(7, 13)

  numCols = numCols % 2 == 0 and (numCols + 1) or numCols

  local highestTier = math.min(3, math.floor(level / 5))
  local highestColor = math.min(5, level % 5 + 3)
  local lockedBricks = 0

  for y = 1, numRows do

    -- Determines if the current row will have skips on it.
    local skipPattern = math.random(2) == 1 and true or false

    -- Determines if the row will have two color of blocks, alternating
    local alternatePattern = math.random(2) == 1 and true or false

    -- Retrieve alternates. These are used if the alternatePattern flag is true.
    local alternateColor1 = math.random(1, highestColor)
    local alternateColor2 = math.random(1, highestColor)
    local alternateTier1 = math.random(0, highestTier)
    local alternateTier2 = math.random(0, highestTier)

    -- A skip flag: if true, the next block will be skipped.
    local skipFlag = math.random(2) == 1 and true or false

    -- An alternate flag: if true, the next block will be of alternate color
    local alternateFlag = math.random(2) == 1 and true or false

    -- The color and tier to be used if the alternatePattern is not true
    local solidColor = math.random(1, highestColor)
    local solidTier = math.random(0, highestTier)

    for x = 1, numCols do

      if skipPattern then
        -- If skipping pattern is enabled, flip this flag.
        -- If skipping pattern is not enabled and this flag is true,
        -- then the whole row is skipped.
        skipFlag = not skipFlag
      end

      if skipFlag then
        -- Force to skip the rest of the processing.
        goto continue
      end

      -- Actual brick addition
      b = Brick((x - 1) * 32 + 8 + (13 - numCols) * 16, y * 16)

      -- if we're alternating, figure out which color/tier we're on
      if alternatePattern and alternateFlag then
        b.color = alternateColor1
        b.tier = alternateTier1
        alternateFlag = not alternateFlag
      else
        b.color = alternateColor2
        b.tier = alternateTier2
        alternateFlag = not alternateFlag
      end

      -- if not alternating and we made it here, use the solid color/tier
      if not alternatePattern then
        b.color = solidColor
        b.tier = solidTier
      end

      if math.random(10) == 1 then
        -- One last flag for locking the brick.
        lockedBricks = lockedBricks + 1
        b.locked = true
      end
      table.insert(bricks, b)

      ::continue::
    end
  end

  if #bricks == 0 then
    return LevelMaker.createMap(level)
  else
    return bricks, lockedBricks
  end
end