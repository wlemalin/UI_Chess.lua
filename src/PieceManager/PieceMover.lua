local PieceMover = {}
local PieceInitializer = require("src.PieceManager.PieceInitializer") -- Si nécessaire pour récupérer les pièces

-- Méthode pour valider si un mouvement est autorisé
function PieceMover:isValidMove(pieces, piece, destinationIndex)
    -- Vérifier si la case cible contient une pièce alliée
    local targetPiece = PieceInitializer:getPieceAtIndex(pieces, destinationIndex)
    if targetPiece and targetPiece.color == piece.color then
        return false -- Mouvement invalide : destination occupée par une pièce alliée
    end

    -- Ajouter d'autres règles de validation ici...

    return true -- Mouvement valide
end

function PieceMover:movePiece(pieces, piece, destinationIndex)
    -- Valider le mouvement
    if not self:isValidMove(pieces, piece, destinationIndex) then
        print("Mouvement refusé : case occupée par une pièce alliée.")
        return false
    end

    -- Vérifier si une pièce ennemie se trouve sur la case cible
    local targetPiece = PieceInitializer:getPieceAtIndex(pieces, destinationIndex)
    if targetPiece and targetPiece.color ~= piece.color then
        self:capturePiece(pieces, piece.index, destinationIndex)
    else
        -- Déplacer normalement si aucune capture
        piece.index = destinationIndex
    end

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


return PieceMover

