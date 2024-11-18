local PieceMover = {}
local PieceInitializer = require("src.PieceManager.PieceInitializer")


function PieceMover:isPseudoLegal(pieces, piece, destinationIndex)
    local targetPiece = PieceInitializer:getPieceAtIndex(pieces, destinationIndex)
    if targetPiece and targetPiece.color == piece.color then
        return false -- Mouvement invalide : occupée par pièce alliée
    end

  if piece.type == "pawn" then
      return self:isValidPawnMove(pieces, piece, destinationIndex)
  end

  if piece.type == "knight" then
      return self:isValidKnightMove(pieces, piece, destinationIndex)
  end

  if piece.type == "bishop" then
      return self:isValidBishopMove(pieces, piece, destinationIndex)
  end

  if piece.type == "rook" then
      return self:isValidRookMove(pieces, piece, destinationIndex)
  end

  if piece.type == "queen" then
      return self:isValidQueenMove(pieces, piece, destinationIndex)
  end

  if piece.type == "king" then
      return self:isValidKingMove(pieces, piece, destinationIndex)
  end

    return true -- Valid move
end

function PieceMover:movePiece(pieces, piece, destinationIndex)
    print(pieces, destinationIndex)
    if not self:isPseudoLegal(pieces, piece, destinationIndex) then
        return false
    elseif not self:isLegal(pieces, piece, destinationIndex) then
        return false
    end

    -- Check if target square is occupied
    local targetPiece = PieceInitializer:getPieceAtIndex(pieces, destinationIndex)
    if targetPiece and targetPiece.color ~= piece.color then
        self:capturePiece(pieces, piece.index, destinationIndex)
    end

    -- Actual move
    piece.index = destinationIndex
    return true
end



function PieceMover:capturePiece(pieces, fromIndex, toIndex)
    -- Find the piece to capture
    for i, piece in ipairs(pieces) do
        if piece.index == toIndex then
            table.remove(pieces, i) -- Remove it
            break
        end
    end

    -- Find attacker and move it
    for _, piece in ipairs(pieces) do
        if piece.index == fromIndex then
            piece.index = toIndex -- Déplacer la pièce attaquante
            break
        end
    end
end


function PieceMover:isValidPawnMove(pieces, piece, targetIndex)
    local startIndex = piece.index
    -- Determine direction using color
    local direction = (piece.color == "white") and 1 or -1
    print(startIndex, targetIndex)

    -- Move 1 square up
    if targetIndex == startIndex + (24 * direction) then
        if not PieceInitializer:getPieceAtIndex(pieces, targetIndex) then
            return true
        end
    end

    -- Move 2 squares up
    local startRow = math.floor((startIndex - 1) / 24) + 1
    if targetIndex == startIndex + (48 * direction) and
       ((piece.color == "white" and startRow == 2) or (piece.color == "black" and startRow == 7)) then
        if not PieceInitializer:getPieceAtIndex(pieces, startIndex + (24 * direction)) and
           not PieceInitializer:getPieceAtIndex(pieces, targetIndex) then
            return true
        end
    end

    -- Normal take (left)
    if targetIndex == startIndex + (23 * direction) then
        local targetPiece = PieceInitializer:getPieceAtIndex(pieces, targetIndex)
        if targetPiece and targetPiece.color ~= piece.color then
            return true
        end

    end

    -- Normal take (right)
    if targetIndex == startIndex + (25 * direction) then
        local targetPiece = PieceInitializer:getPieceAtIndex(pieces, targetIndex)
        if targetPiece and targetPiece.color ~= piece.color then
            return true
        end
    end
    return false
end

function PieceMover:isValidKnightMove(pieces, piece, destinationIndex)
    local knightMoves = {49, 47, 26, 22}
    local startIndex = piece.index

    for _, move in ipairs(knightMoves) do
        if destinationIndex == startIndex + move or destinationIndex == startIndex - move then
            local targetPiece = PieceInitializer:getPieceAtIndex(pieces, destinationIndex)
            if not targetPiece or targetPiece.color ~= piece.color then
                return true
            end
        end
    end

    return false
end

function PieceMover:isValidBishopMove(pieces, piece, destinationIndex)
    local startIndex = piece.index
    local delta = destinationIndex - startIndex

    local step = nil
    if math.abs(delta) % 23 == 0 then
        step = 23
    elseif math.abs(delta) % 25 == 0 then
        step = 25
    else
        return false -- Non diagonal move
    end

    -- Move on the diagonale
    local direction = step * (delta > 0 and 1 or -1)
    local currentIndex = startIndex + direction

    while currentIndex ~= destinationIndex do
        local blockingPiece = PieceInitializer:getPieceAtIndex(pieces, currentIndex)
        if blockingPiece then
            return false -- Path is obstructed
        end
        currentIndex = currentIndex + direction -- One square in diagonal
    end

    local targetPiece = PieceInitializer:getPieceAtIndex(pieces, destinationIndex)
    if not targetPiece or targetPiece.color ~= piece.color then
        return true -- Valid move
    else
        return false
    end
end

function PieceMover:isValidRookMove(pieces, piece, destinationIndex)
    local startIndex = piece.index
    local delta = destinationIndex - startIndex

    -- Check if horizontal or vertical
    local step = nil
    if delta % 24 == 0 then
        step = 24 -- vertical
    elseif math.abs(delta) < 7 then
        step = 1 -- horizontal
    else
        return false -- Invalid move
    end

    -- Direction
    local direction = step * (delta > 0 and 1 or -1)
    local currentIndex = startIndex + direction

    -- Travel the path
    while currentIndex ~= destinationIndex do
        local blockingPiece = PieceInitializer:getPieceAtIndex(pieces, currentIndex)
        if blockingPiece then
            return false
        end
        currentIndex = currentIndex + direction -- Avance d'une étape
    end

    local targetPiece = PieceInitializer:getPieceAtIndex(pieces, destinationIndex)
    if not targetPiece or targetPiece.color ~= piece.color then
        return true
    else
        return false
    end
end

function PieceMover:isValidQueenMove(pieces, piece, destinationIndex)
    return (PieceMover:isValidBishopMove(pieces, piece, destinationIndex) or PieceMover:isValidRookMove(pieces, piece, destinationIndex))
end

function PieceMover:isValidKingMove(pieces, piece, destinationIndex)
    local startIndex = piece.index
    local targetPiece = PieceInitializer:getPieceAtIndex(pieces, destinationIndex)

    if targetPiece ~= nil and targetPiece.color == piece.color then
        return false
    end

    -- Vérifie si le déplacement est valide (une des valeurs spécifiques)
    local delta = math.abs(startIndex - destinationIndex)
    if delta == 23 or delta == 25 or delta == 1 or delta == 24 then
        return true
    end

    return false
end

function PieceMover:isLegal(pieces, piece, destinationIndex)
    -- Sauvegarder l'état initial
    local originalStartIndex = piece.index
    local pseudoTakenPiece = PieceInitializer:getPieceAtIndex(pieces, destinationIndex)

    -- Simule le mouvement
    piece.index = destinationIndex
    if pseudoTakenPiece ~= nil then
        pseudoTakenPiece.index = nil -- Retire temporairement la pièce capturée
    end

    -- Vérifie si le roi est en échec après le mouvement
    local isKingInCheck = self:isKingInCheck(pieces, piece.color)

    -- Annule le mouvement (restaure l'état initial)
    piece.index = originalStartIndex
    if pseudoTakenPiece ~= nil then
        pseudoTakenPiece.index = destinationIndex
    end

    -- Retourne vrai si le roi n'est pas en échec
    return not isKingInCheck
end


function PieceMover:isKingInCheck(pieces, kingColor)
    -- Trouver la position du roi de la couleur donnée
    local kingPosition = nil
    for _, piece in ipairs(pieces) do
        if piece.type == "king" and piece.color == kingColor then
            kingPosition = piece.index
            break
        end
    end

    -- Vérifie si une pièce ennemie peut atteindre la position du roi
    for _, piece in ipairs(pieces) do
        if piece.color ~= kingColor then
            if self:isPseudoLegal(pieces, piece, kingPosition) then
                return true -- King in check
            end
        end
    end

    return false -- King not in check
end


return PieceMover

