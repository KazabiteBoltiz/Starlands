local ServerS = game:GetService('ServerScriptService')
local Systems = ServerS.Systems
local Ability = Systems.Ability
local AbilityStatus = require(Ability.Status)

local Charge = {
    Status = AbilityStatus.Open
}

function Charge.Start(Battle, Ability, PlayerData)
    Battle.Status:Set(AbilityStatus.Locked)
    task.wait(1)
    Ability:Switch('Swing', PlayerData)
end

return Charge