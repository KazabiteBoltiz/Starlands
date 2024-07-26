local ServerS = game:GetService('ServerScriptService')
local Systems = ServerS.Systems
local Ability = Systems.Ability
local AbilityStatus = require(Ability.Status)

local Swing = {
    Status = AbilityStatus.Open
}

function Swing.Start(Battle, Ability, PlayerData)
    Battle.Status:Set(AbilityStatus.Open)
end

return Swing