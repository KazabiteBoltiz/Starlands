local ServerS = game:GetService('ServerScriptService')
local Systems = ServerS.Systems
local Ability = Systems.Ability
local AbilityStatus = require(Ability.Status)

local RepS = game:GetService('ReplicatedStorage')
local Packages = RepS.Packages
local Tree = require(Packages.Tree)

local Dash = {
    Status = AbilityStatus.Open,
    EffectPaths = {
        Trail = 'FlashStep/Trail'
    }
}

function Dash.Start(Battle, Ability, PlayerData)
    Battle.Status:Set(AbilityStatus.Locked)
    task.wait(3)
    Battle.Status:Set(AbilityStatus.Open)
end

return Dash