
-- Importer les modules
local BoardRenderer = require("src.BoardRenderer.init")
local PieceManager = require("src.PieceManager.init")
local TurnManager = require("src.TurnManager.init")
local UIManager = require("src.UIManager.init")

-- main.lua

function love.load()
    BoardRenderer:initialize()
    PieceManager:initialize()
    UIManager:initialize()
    TurnManager:initialize()
end

function love.mousepressed(mouseX, mouseY, button)
    if button == 1 then -- Clic gauche uniquement
        -- Obtenir le joueur actuel
        local currentTurn = TurnManager:getCurrentTurn()

        -- Gérer la sélection ou le mouvement
        local selectedPiece = UIManager.selectedPiece
        if selectedPiece then
            -- Si une pièce est déjà sélectionnée, tenter de la déplacer
            local clickedPiece = UIManager:handlePieceSelection(PieceManager:getBoardState(), mouseX, mouseY, currentTurn)
            
            if not clickedPiece then
                -- Calculer la destination à partir de la souris
                local destinationIndex = UIManager:getClickedIndex(mouseX, mouseY)
                if destinationIndex then
                    local moveSuccess = PieceManager:movePiece(selectedPiece, destinationIndex, true)
                    
                    -- Ne changer de tour que si le mouvement est valide
                    if moveSuccess then
                        TurnManager:changeTurn()
                    else
                        print("Tour non changé, mouvement refusé.")
                    end
                end

                -- Désélectionner la pièce après le mouvement
                UIManager.selectedPiece = nil
                UIManager:unselectPiece()
            end
        else
            -- Si aucune pièce n'est sélectionnée, gérer la sélection
            UIManager:handlePieceSelection(PieceManager:getBoardState(), mouseX, mouseY, currentTurn)
        end
    end
end

function love.draw()
    BoardRenderer:drawBoard()
    PieceManager:drawPieces()
    UIManager:drawHighlights()
end


