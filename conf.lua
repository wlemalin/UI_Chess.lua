
-- conf.lua
local constants = require("src.constants")

local squareSize = constants.squareSize

function love.conf(t)
    t.window.width = squareSize * 13 -- 8 + panelSize
    t.window.height = squareSize * 8
    t.window.title = "Échiquier LÖVE"
end
