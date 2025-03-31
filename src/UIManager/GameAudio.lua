local GameAudio = {}

-- Table to hold move sounds
local moveSounds = {}

-- Function to load the move sounds
function GameAudio.load()
    -- Seed the random number generator
    math.randomseed(os.time())
    for i = 1, 10 do
        local soundPath = "assets/sounds/move_" .. i .. ".wav"
        moveSounds[i] = love.audio.newSource(soundPath, "static")
    end
end

-- Function to play a random move sound
function GameAudio.playRandomMoveSound()
    if #moveSounds == 0 then
        print("Sounds not loaded! Call GameAudio.load() first.")
        return
    end
    local randomIndex = math.random(#moveSounds)
    moveSounds[randomIndex]:play()
end

return GameAudio
