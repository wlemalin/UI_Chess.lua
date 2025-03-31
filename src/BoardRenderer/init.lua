local BoardRenderer = {}

local constants = require("src.constants")

local squareSize = constants.squareSize
local lightColor = constants.lightColor
local darkColor = constants.darkColor

local ROWS = constants.rows
local COLUMNS = constants.columns
local PLAYABLE_START = constants.playableStart
local PLAYABLE_END = constants.playableEnd

function BoardRenderer:initialize()
    self.rows = ROWS
    self.cols = COLUMNS
end

function BoardRenderer:drawBoard()
    for row = 1, self.rows do
        for col = PLAYABLE_START, PLAYABLE_END do
            -- Determine square color
            if (row + col) % 2 == 0 then
                love.graphics.setColor(lightColor)
            else
                love.graphics.setColor(darkColor)
            end

            -- Pixel counts
            local x = (col - PLAYABLE_START) * squareSize
            local y = (row - 1) * squareSize

            love.graphics.rectangle("fill", x, y, squareSize, squareSize)
        end
    end

    -- Reset color
    love.graphics.setColor(1, 1, 1)
end

return BoardRenderer
