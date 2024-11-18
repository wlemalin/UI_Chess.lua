local PieceSelection = {}
local constants = require("src.constants")

local squareSize = constants.squareSize
local playableStart = constants.playableStart
local playableEnd = constants.playableEnd
local rows = constants.rows
local columns = constants.columns

function PieceSelection:initialize(uiManager)
    self.UIManager = uiManager
end

function PieceSelection:getClickedPiece(pieces, mouseX, mouseY)
    for _, piece in ipairs(pieces) do
        local row = math.floor((piece.index - 1) / 24) + 1
        local col = (piece.index - 1) % 24 + 1
        if col >= playableStart and col <= 16 then
            local x = (col - playableStart) * squareSize
            local y = (row - 1) * squareSize
            if mouseX >= x and mouseX < x + squareSize and mouseY >= y and mouseY < y + squareSize then
                return piece
            end
        end
    end
    return nil
end

function PieceSelection:highlightSelectedPiece(piece)
    local row = math.floor((piece.index - 1) / 24) + 1
    local col = (piece.index - 1) % 24 + 1
    local x = (col - playableStart) * squareSize
    local y = (row - 1) * squareSize

    love.graphics.setColor(0, 1, 0, 0.5)
    love.graphics.rectangle("fill", x, y, squareSize, squareSize)
    love.graphics.setColor(1, 1, 1)
end


function PieceSelection:getClickedIndex(mouseX, mouseY)
    assert(squareSize, "squareSize is nil")
    assert(playableStart, "PLAYABLE_START is nil")
    assert(playableEnd, "PLAYABLE_END is nil")
    assert(rows, "ROWS is nil")
    assert(columns, "COLUMNS is nil")
    local col = math.floor(mouseX / squareSize) + playableStart
    local row = math.floor(mouseY / squareSize) + 1

    -- Vérifier si la case est dans les limites jouables
    if col >= playableStart and col <= playableEnd and row >= 1 and row <= rows then
        return (row - 1) * columns + col -- Calculer l'index linéaire
    end
    return nil
end


function PieceSelection:unselectPiece()
    self.UIManager.selectedPiece = nil
end


function PieceSelection:handlePieceSelection(pieces, mouseX, mouseY, currentTurn)
    local clickedPiece = self:getClickedPiece(pieces, mouseX, mouseY)

    if clickedPiece and clickedPiece.color == currentTurn then
        self.UIManager.selectedPiece = clickedPiece
    else
        self.UIManager.selectedPiece = nil
    end
end

return PieceSelection
