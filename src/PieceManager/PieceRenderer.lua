
local PieceRenderer = {}

local pieceImages = {}
local squareSize = 80
local PLAYABLE_START = 9

function PieceRenderer:initializeImages()
    -- Charger les images des pièces
    pieceImages = {
        ["white_king"] = love.graphics.newImage("assets/images/pieces/wk.png"),
        ["white_queen"] = love.graphics.newImage("assets/images/pieces/wq.png"),
        ["white_rook"] = love.graphics.newImage("assets/images/pieces/wr.png"),
        ["white_bishop"] = love.graphics.newImage("assets/images/pieces/wb.png"),
        ["white_knight"] = love.graphics.newImage("assets/images/pieces/wn.png"),
        ["white_pawn"] = love.graphics.newImage("assets/images/pieces/wp.png"),
        ["black_king"] = love.graphics.newImage("assets/images/pieces/bk.png"),
        ["black_queen"] = love.graphics.newImage("assets/images/pieces/bq.png"),
        ["black_rook"] = love.graphics.newImage("assets/images/pieces/br.png"),
        ["black_bishop"] = love.graphics.newImage("assets/images/pieces/bb.png"),
        ["black_knight"] = love.graphics.newImage("assets/images/pieces/bn.png"),
        ["black_pawn"] = love.graphics.newImage("assets/images/pieces/bp.png"),
    }
end

function PieceRenderer:drawPieces(pieces)
    for _, piece in ipairs(pieces) do
        -- Convertir l'index en coordonnées 2D
        local row = math.floor((piece.index - 1) / 24) + 1
        local col = (piece.index - 1) % 24 + 1

        -- Dessiner uniquement les colonnes jouables
        if col >= PLAYABLE_START and col <= 16 then
            local x = (col - PLAYABLE_START) * squareSize
            local y = (row - 1) * squareSize

            -- Obtenir l'image associée
            local imageKey = piece.color .. "_" .. piece.type
            local image = pieceImages[imageKey]

            if image then
                love.graphics.draw(image, x, y, 0, squareSize / image:getWidth(), squareSize / image:getHeight())
            else
                -- Affichage de secours
                love.graphics.print(piece.type, x + squareSize / 4, y + squareSize / 4)
            end
        end
    end
end

return PieceRenderer
