local UIManager = {}
-- local PieceSelection = require("src.UIManager.PieceSelection")

function UIManager:initialize()
    self.selectedPiece = nil
    self.pieceSelection = require("src.UIManager.PieceSelection")
    self.pieceSelection:initialize(self) -- Passer l'instance de UIManager
end


-- Redirect to correct submodule
function UIManager:handlePieceSelection(pieces, mouseX, mouseY, currentTurn)
    return self.pieceSelection:handlePieceSelection(pieces, mouseX, mouseY, currentTurn)
end
function UIManager:getClickedIndex(mouseX, mouseY)
    return self.pieceSelection:getClickedIndex(mouseX, mouseY)
end
function UIManager:drawHighlights()
    if self.selectedPiece then
        self.pieceSelection:highlightSelectedPiece(self.selectedPiece)
    end
end
function UIManager:unselectPiece()
    if self.pieceSelection then
        self.pieceSelection:unselectPiece()
    end
end

return UIManager
