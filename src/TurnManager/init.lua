
-- src/TurnManager/init.lua

local TurnManager = {}

function TurnManager:initialize()
    self.currentTurn = "white"
end

function TurnManager:changeTurn()
    if self.currentTurn == "white" then
        self.currentTurn = "black"
    else
        self.currentTurn = "white"
    end
end

function TurnManager:getCurrentTurn()
    return self.currentTurn
end

return TurnManager
