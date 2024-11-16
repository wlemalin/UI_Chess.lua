local BoardRenderer = {}

-- Taille de chaque case
local squareSize = 80

-- Couleurs des cases (alternées)
local lightColor = {1, 0.9, 0.8} -- couleur claire
local darkColor = {0.6, 0.4, 0.2} -- couleur sombre

-- Configuration des dimensions de l'échiquier
local ROWS = 8
local COLUMNS = 24 -- Inclut le padding
local PLAYABLE_START = 9
local PLAYABLE_END = 16

-- Fonction d'initialisation
function BoardRenderer:initialize()
    -- Dimensions complètes de l'échiquier (avec padding)
    self.rows = ROWS
    self.cols = COLUMNS
end

-- Fonction pour dessiner uniquement les cases jouables
function BoardRenderer:drawBoard()
    for row = 1, self.rows do
        for col = PLAYABLE_START, PLAYABLE_END do -- Limite aux colonnes jouables
            -- Détermine la couleur de la case
            if (row + col) % 2 == 0 then
                love.graphics.setColor(lightColor)
            else
                love.graphics.setColor(darkColor)
            end

            -- Calcul des coordonnées graphiques des cases jouables
            local x = (col - PLAYABLE_START) * squareSize -- Décale pour démarrer à 0
            local y = (row - 1) * squareSize

            -- Dessine le rectangle
            love.graphics.rectangle("fill", x, y, squareSize, squareSize)
        end
    end

    -- Réinitialiser la couleur pour éviter des effets sur d'autres dessins
    love.graphics.setColor(1, 1, 1)
end

return BoardRenderer
