local PieceSelection = {}
local constants = require("src.constants")

local squareSize = constants.squareSize
local PLAYABLE_START = constants.PLAYABLE_START
local PLAYABLE_END = constants.PLAYABLE_END
local ROWS = constants.ROWS
local COLUMNS = constants.COLUMNS

function PieceSelection:initialize(uiManager)
    self.UIManager = uiManager -- Stocker l'instance si nécessaire
end

function PieceSelection:getClickedPiece(pieces, mouseX, mouseY)
    for _, piece in ipairs(pieces) do
        local row = math.floor((piece.index - 1) / 24) + 1
        local col = (piece.index - 1) % 24 + 1
        if col >= PLAYABLE_START and col <= 16 then
            local x = (col - PLAYABLE_START) * squareSize
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
    local x = (col - PLAYABLE_START) * squareSize
    local y = (row - 1) * squareSize

    love.graphics.setColor(0, 1, 0, 0.5)
    love.graphics.rectangle("fill", x, y, squareSize, squareSize)
    love.graphics.setColor(1, 1, 1)
end


function PieceSelection:getClickedIndex(mouseX, mouseY)
    assert(squareSize, "squareSize is nil")
    assert(PLAYABLE_START, "PLAYABLE_START is nil")
    assert(PLAYABLE_END, "PLAYABLE_END is nil")
    assert(ROWS, "ROWS is nil")
    assert(COLUMNS, "COLUMNS is nil")
    local col = math.floor(mouseX / squareSize) + PLAYABLE_START
    local row = math.floor(mouseY / squareSize) + 1

    -- Vérifier si la case est dans les limites jouables
    if col >= PLAYABLE_START and col <= PLAYABLE_END and row >= 1 and row <= ROWS then
        return (row - 1) * COLUMNS + col -- Calculer l'index linéaire
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
