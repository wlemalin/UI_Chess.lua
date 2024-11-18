local PieceMover = {}
local PieceInitializer = require("src.PieceManager.PieceInitializer") -- Si nécessaire pour récupérer les pièces


function PieceMover:isValidMove(pieces, piece, destinationIndex)
    local targetPiece = PieceInitializer:getPieceAtIndex(pieces, destinationIndex)
    if targetPiece and targetPiece.color == piece.color then
        return false -- Mouvement invalide : destination occupée par une pièce alliée
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

    return true -- Mouvement valide
end

function PieceMover:movePiece(pieces, piece, destinationIndex)
    -- Valider le mouvement
    print(pieces, destinationIndex)
    if not self:isValidMove(pieces, piece, destinationIndex) then
        return false
    end

    -- Vérifier si une pièce ennemie se trouve sur la case cible
    local targetPiece = PieceInitializer:getPieceAtIndex(pieces, destinationIndex)
    if targetPiece and targetPiece.color ~= piece.color then
        self:capturePiece(pieces, piece.index, destinationIndex)
    end

    -- Déplacer normalement si aucune capture
    piece.index = destinationIndex
    return true -- Mouvement réussi
end



function PieceMover:capturePiece(pieces, fromIndex, toIndex)
    -- Trouver la pièce à capturer
    for i, piece in ipairs(pieces) do
        if piece.index == toIndex then
            table.remove(pieces, i) -- Supprimer la pièce capturée
            break
        end
    end

    -- Trouver la pièce attaquante et la déplacer
    for _, piece in ipairs(pieces) do
        if piece.index == fromIndex then
            piece.index = toIndex -- Déplacer la pièce attaquante
            break
        end
    end
end


function PieceMover:isValidPawnMove(pieces, piece, targetIndex)
    local startIndex = piece.index
    -- Détermine la direction en fonction de la couleur
    local direction = (piece.color == "white") and 1 or -1
    print(startIndex, targetIndex)

    -- Déplacement simple
    if targetIndex == startIndex + (24 * direction) then
        if not PieceInitializer:getPieceAtIndex(pieces, targetIndex) then
            return true
        end
    end

    -- Déplacement double depuis la rangée de départ
    local startRow = math.floor((startIndex - 1) / 24) + 1
    if targetIndex == startIndex + (48 * direction) and
       ((piece.color == "white" and startRow == 2) or (piece.color == "black" and startRow == 7)) then
        if not PieceInitializer:getPieceAtIndex(pieces, startIndex + (24 * direction)) and
           not PieceInitializer:getPieceAtIndex(pieces, targetIndex) then
            return true
        end
    end

    -- Prise en diagonale gauche
    if targetIndex == startIndex + (23 * direction) then
        local targetPiece = PieceInitializer:getPieceAtIndex(pieces, targetIndex)
        if targetPiece and targetPiece.color ~= piece.color then
            return true -- Prise normale
        end

    end

    -- Prise en diagonale droite
    if targetIndex == startIndex + (25 * direction) then
        local targetPiece = PieceInitializer:getPieceAtIndex(pieces, targetIndex)
        if targetPiece and targetPiece.color ~= piece.color then
            return true -- Prise normale
        end

    end
    return false
end

function PieceMover:isValidKnightMove(pieces, piece, destinationIndex)
    local knightMoves = {49, 47, 26, 22}
    local startIndex = piece.index

    -- Vérifie si la destination correspond à un mouvement valide du cavalier
    for _, move in ipairs(knightMoves) do
        if destinationIndex == startIndex + move or destinationIndex == startIndex - move then
            -- Vérifie si la case cible contient une pièce alliée
            print(destinationIndex, "from", startIndex)
            local targetPiece = PieceInitializer:getPieceAtIndex(pieces, destinationIndex)
            if not targetPiece or targetPiece.color ~= piece.color then
                return true -- Mouvement valide
            end
        end
    end

    return false -- Aucun mouvement valide trouvé
end

function PieceMover:isValidBishopMove(pieces, piece, destinationIndex)
    local startIndex = piece.index

    -- Détermine le pas (step) correspondant à la diagonale choisie
    local delta = destinationIndex - startIndex

    -- Vérifie si le mouvement est bien diagonal (delta doit être divisible par un pas valide)
    local step = nil
    if math.abs(delta) % 23 == 0 then
        step = 23
    elseif math.abs(delta) % 25 == 0 then
        step = 25
    else
        return false -- Mouvement non diagonal
    end

    -- Parcourt la diagonale correspondant au mouvement
    local direction = step * (delta > 0 and 1 or -1) -- Direction basée sur le signe de delta
    local currentIndex = startIndex + direction

    while currentIndex ~= destinationIndex do
        -- Vérifie s'il y a une pièce bloquant le chemin
        local blockingPiece = PieceInitializer:getPieceAtIndex(pieces, currentIndex)
        if blockingPiece then
            return false -- Chemin bloqué avant d'atteindre la destination
        end
        currentIndex = currentIndex + direction -- Avance d'une étape dans la diagonale
    end

    -- Vérifie la case de destination
    local targetPiece = PieceInitializer:getPieceAtIndex(pieces, destinationIndex)
    if not targetPiece or targetPiece.color ~= piece.color then
        return true -- Mouvement valide (destination vide ou pièce ennemie)
    else
        return false -- Mouvement invalide (pièce alliée à destination)
    end
end

function PieceMover:isValidRookMove(pieces, piece, destinationIndex)
    local startIndex = piece.index

    -- Calcul de la différence entre la destination et le départ
    local delta = destinationIndex - startIndex

    -- Vérifie si le mouvement est horizontal ou vertical
    local step = nil
    if delta % 24 == 0 then
        step = 24 -- Mouvement vertical (dans la même colonne)
    elseif math.abs(delta) < 7 then
        step = 1 -- Mouvement horizontal (dans la même ligne)
    else
        return false -- Mouvement invalide (ni horizontal ni vertical)
    end

    -- Détermine la direction (1 pour avancer, -1 pour reculer)
    local direction = step * (delta > 0 and 1 or -1)
    local currentIndex = startIndex + direction

    -- Parcourt les cases intermédiaires
    while currentIndex ~= destinationIndex do
        local blockingPiece = PieceInitializer:getPieceAtIndex(pieces, currentIndex)
        if blockingPiece then
            return false
        end
        currentIndex = currentIndex + direction -- Avance d'une étape
    end

    -- Vérifie la case de destination
    local targetPiece = PieceInitializer:getPieceAtIndex(pieces, destinationIndex)
    if not targetPiece or targetPiece.color ~= piece.color then
        return true -- Mouvement valide (destination vide ou pièce ennemie)
    else
        return false -- Mouvement invalide (pièce alliée à destination)
    end
end

function PieceMover:isValidQueenMove(pieces, piece, destinationIndex)
    return (PieceMover:isValidBishopMove(pieces, piece, destinationIndex) or PieceMover:isValidRookMove(pieces, piece, destinationIndex))
end

function PieceMover:isValidKingMove(pieces, piece, destinationIndex)
    local startIndex = piece.index
    local targetPiece = PieceInitializer:getPieceAtIndex(pieces, destinationIndex)

    -- Vérifie si la case destination est occupée par une pièce alliée
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

return PieceMover

