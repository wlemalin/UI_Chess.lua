
local PieceInitializer = {}


local COLUMNS = 24 -- Include padding

-- Convert 2D to linear index
local function toIndex(row, col)
    return (row - 1) * COLUMNS + col
end


function PieceInitializer:initializePieces()
    local pieces = {}

    for col = 9, 16 do
        table.insert(pieces, {type = "pawn", color = "white", index = toIndex(2, col)})
    end
    table.insert(pieces, {type = "rook", color = "white", index = toIndex(1, 9)})
    table.insert(pieces, {type = "knight", color = "white", index = toIndex(1, 10)})
    table.insert(pieces, {type = "bishop", color = "white", index = toIndex(1, 11)})
    table.insert(pieces, {type = "queen", color = "white", index = toIndex(1, 12)})
    table.insert(pieces, {type = "king", color = "white", index = toIndex(1, 13)})
    table.insert(pieces, {type = "bishop", color = "white", index = toIndex(1, 14)})
    table.insert(pieces, {type = "knight", color = "white", index = toIndex(1, 15)})
    table.insert(pieces, {type = "rook", color = "white", index = toIndex(1, 16)})

    for col = 9, 16 do
        table.insert(pieces, {type = "pawn", color = "black", index = toIndex(7, col)})
    end

    table.insert(pieces, {type = "rook", color = "black", index = toIndex(8, 9)})
    table.insert(pieces, {type = "knight", color = "black", index = toIndex(8, 10)})
    table.insert(pieces, {type = "bishop", color = "black", index = toIndex(8, 11)})
    table.insert(pieces, {type = "queen", color = "black", index = toIndex(8, 12)})
    table.insert(pieces, {type = "king", color = "black", index = toIndex(8, 13)})
    table.insert(pieces, {type = "bishop", color = "black", index = toIndex(8, 14)})
    table.insert(pieces, {type = "knight", color = "black", index = toIndex(8, 15)})
    table.insert(pieces, {type = "rook", color = "black", index = toIndex(8, 16)})

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
