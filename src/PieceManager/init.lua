local PieceManager = {}
local PieceInitializer = require("src.PieceManager.PieceInitializer")
local PieceRenderer = require("src.PieceManager.PieceRenderer")
local PieceMover = require("src.PieceManager.PieceMover")



function PieceManager:initialize()
    -- Initialiser les pièces avec leur position et images
    self.pieces = PieceInitializer:initializePieces()
    PieceRenderer:initializeImages()
end

function PieceManager:drawPieces()
    -- Déléguer le rendu des pièces au module `PieceRenderer`
    PieceRenderer:drawPieces(self.pieces)
end

function PieceManager:movePiece(piece, destinationIndex)
    return PieceMover:movePiece(self.pieces, piece, destinationIndex)
end

function PieceManager:getBoardState()
    return self.pieces
end

function PieceManager:getPieceAtIndex(index)
    return PieceInitializer:getPieceAtIndex(self.pieces, index)
end

return PieceManager
