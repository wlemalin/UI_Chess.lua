
local BoardRenderer = require("src.BoardRenderer.init")
local PieceManager = require("src.PieceManager.init")
local TurnManager = require("src.TurnManager.init")
local UIManager = require("src.UIManager.init")
local GameAudio = require("src.UIManager.GameAudio")


-- main.lua

function love.load()
    BoardRenderer:initialize()
    PieceManager:initialize()
    UIManager:initialize()
    TurnManager:initialize()
    GameAudio:load()
end

function love.draw()
    BoardRenderer:drawBoard()
    PieceManager:drawPieces()
    UIManager:drawHighlights()
end


function love.mousepressed(mouseX, mouseY, button)
    -- Left click only
    if button ~= 1 then
        return
    end

    local currentTurn = TurnManager:getCurrentTurn()
    local boardState = PieceManager:getBoardState()

    -- Check if a piece is already selected
    local selectedPiece = UIManager.selectedPiece
    if not selectedPiece then
        -- Try new selection
        UIManager:handlePieceSelection(boardState, mouseX, mouseY, currentTurn)
        return
    end

    local clickedPiece = UIManager:handlePieceSelection(boardState, mouseX, mouseY, currentTurn)
    if clickedPiece then
        return -- New piece has been selected
    end

    local destinationIndex = UIManager:getClickedIndex(mouseX, mouseY)
    if not destinationIndex then
        return -- No valid index clicked
    end

    local moveSuccess = PieceManager:movePiece(selectedPiece, destinationIndex)
    if moveSuccess then
        GameAudio:playRandomMoveSound()
        TurnManager:changeTurn()
    else
        print("Invalid move!")
    end

    -- Unselect piece after moving
    UIManager.selectedPiece = nil
    UIManager:unselectPiece()
end


