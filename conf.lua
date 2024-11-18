
-- conf.lua

function love.conf(t)
    local squareSize = 80  -- Same as in `BoardRenderer`
    t.window.width = squareSize * 13 -- 8 + panelSize
    t.window.height = squareSize * 8
    t.window.title = "Échiquier LÖVE"
end
