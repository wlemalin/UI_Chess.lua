-- src/TurnManager/init.lua

local TurnManager = {}

-- Initialisation : les blancs commencent toujours
function TurnManager:initialize()
    self.currentTurn = "white"  -- Les blancs commencent
end

-- Vérifie si c'est le tour de la couleur donnée
function TurnManager:isTurn(color)
    return self.currentTurn == color
end

-- Change de tour après un mouvement valide
function TurnManager:changeTurn()
    if self.currentTurn == "white" then
        self.currentTurn = "black"
    else
        self.currentTurn = "white"
    end
end

-- Fonction pour obtenir le joueur actuel (utile pour l'interface)
function TurnManager:getCurrentTurn()
    return self.currentTurn
end

return TurnManager
