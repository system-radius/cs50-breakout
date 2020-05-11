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

  local flooredLevel = math.floor((level - 1) / 5)
  local highestTier = math.min(3, flooredLevel)
  local highestColor = ((level - 1) % 5) + 1
  local minColor = math.min(flooredLevel + 1, highestColor)
  local lockedBricks = 0

  for y = 1, numRows do

    -- Determines if the current row will have skips on it.
    local skipPattern = math.random(2) == 1 and true or false

    -- Determines if the row will have two color of blocks, alternating
    local alternatePattern = math.random(2) == 1 and true or false

    -- Retrieve alternates. These are used if the alternatePattern flag is true.
    local alternateColor1 = math.random(minColor, highestColor)
    local alternateColor2 = math.random(minColor, highestColor)
    local alternateTier1 = math.random(0, highestTier)
    local alternateTier2 = math.random(0, highestTier)

    -- A skip flag: if true, the next block will be skipped.
    local skipFlag = math.random(2) == 1 and true or false

    -- An alternate flag: if true, the next block will be of alternate color
    local alternateFlag = math.random(2) == 1 and true or false

    -- The color and tier to be used if the alternatePattern is not true
    local solidColor = math.random(minColor, highestColor)
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

      -- Actual brick creation
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
      table.insert(bricks, b)

      ::continue::
    end
  end

  if #bricks == 0 then
    return LevelMaker.createMap(level)
  else

    local limit = math.floor(#bricks / 2)
    -- lock some of the bricks.
    while limit > 0 do
      local b = bricks[math.random(#bricks)]
      if math.random(4) == 1 then
        -- One last flag for locking the brick.
        b.locked = true

        -- Keep track of the locked bricks for key generation
        lockedBricks = lockedBricks + 1
      end

      -- Regardless of whether a brick was locked or not, the limit will decrease
      limit = limit - 1
    end

    -- For each of the locked bricks
    while lockedBricks > 0 do

      local randomIndex = math.random(#bricks)

      local brick = bricks[randomIndex]
      if not (brick.locked or brick.hasKey) then
        brick.hasKey = true
        lockedBricks = lockedBricks - 1
      end
    end

    return bricks, 0
  end
end