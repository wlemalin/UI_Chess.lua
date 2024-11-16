
-- conf.lua
function love.conf(t)
    local squareSize = 80  -- Assurez-vous que cela correspond à la taille de case dans `BoardRenderer`
    t.window.width = squareSize * 13
    t.window.height = squareSize * 8
    t.window.title = "Échiquier LÖVE"
end
