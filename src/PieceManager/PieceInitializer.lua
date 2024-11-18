
local PieceInitializer = {}

local ROWS = 8
local COLUMNS = 24 -- Inclut le padding
local PLAYABLE_START = 9
local PLAYABLE_END = 16

-- Convertir une position 2D en index linéaire
local function toIndex(row, col)
    return (row - 1) * COLUMNS + col
end

-- Initialiser les pièces avec leurs positions
function PieceInitializer:initializePieces()
    local pieces = {}

    -- Ajouter les pièces blanches
    for col = PLAYABLE_START, PLAYABLE_END do
        table.insert(pieces, {type = "pawn", color = "white", index = toIndex(2, col)})
    end
    table.insert(pieces, {type = "rook", color = "white", index = toIndex(1, PLAYABLE_START)})
    table.insert(pieces, {type = "knight", color = "white", index = toIndex(1, PLAYABLE_START + 1)})
    table.insert(pieces, {type = "bishop", color = "white", index = toIndex(1, PLAYABLE_START + 2)})
    table.insert(pieces, {type = "queen", color = "white", index = toIndex(1, PLAYABLE_START + 3)})
    table.insert(pieces, {type = "king", color = "white", index = toIndex(1, PLAYABLE_START + 4)})
    table.insert(pieces, {type = "bishop", color = "white", index = toIndex(1, PLAYABLE_END - 2)})
    table.insert(pieces, {type = "knight", color = "white", index = toIndex(1, PLAYABLE_END - 1)})
    table.insert(pieces, {type = "rook", color = "white", index = toIndex(1, PLAYABLE_END)})

    -- Ajouter les pièces noires
    for col = PLAYABLE_START, PLAYABLE_END do
        table.insert(pieces, {type = "pawn", color = "black", index = toIndex(7, col)})
    end
    table.insert(pieces, {type = "rook", color = "black", index = toIndex(8, PLAYABLE_START)})
    table.insert(pieces, {type = "knight", color = "black", index = toIndex(8, PLAYABLE_START + 1)})
    table.insert(pieces, {type = "bishop", color = "black", index = toIndex(8, PLAYABLE_START + 2)})
    table.insert(pieces, {type = "queen", color = "black", index = toIndex(8, PLAYABLE_START + 3)})
    table.insert(pieces, {type = "king", color = "black", index = toIndex(8, PLAYABLE_START + 4)})
    table.insert(pieces, {type = "bishop", color = "black", index = toIndex(8, PLAYABLE_END - 2)})
    table.insert(pieces, {type = "knight", color = "black", index = toIndex(8, PLAYABLE_END - 1)})
    table.insert(pieces, {type = "rook", color = "black", index = toIndex(8, PLAYABLE_END)})

    return pieces
end

-- Obtenir une pièce à partir de son index
function PieceInitializer:getPieceAtIndex(pieces, index)
    for _, piece in ipairs(pieces) do
        if piece.index == index then
            print(piece.index, "is", piece.type)
            return piece
        end
    end
    return nil
end

return PieceInitializer
