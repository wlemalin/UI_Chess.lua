local BoardRenderer = {}

local squareSize = 80
local lightColor = {1, 0.9, 0.8} -- white square
local darkColor = {0.6, 0.4, 0.2} -- dark square

local ROWS = 8
local COLUMNS = 24 -- Include padding
local PLAYABLE_START = 9
local PLAYABLE_END = 16

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
