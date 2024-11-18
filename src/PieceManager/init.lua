local PieceManager = {}
local PieceInitializer = require("src.PieceManager.PieceInitializer")
local PieceRenderer = require("src.PieceManager.PieceRenderer")
local PieceMover = require("src.PieceManager.PieceMover")



function PieceManager:initialize()
    self.pieces = PieceInitializer:initializePieces()
    PieceRenderer:initializeImages()
end

function PieceManager:drawPieces()
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
