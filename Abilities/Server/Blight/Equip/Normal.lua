local ContextActionService = game:GetService('ContextActionService')
local ServerS = game:GetService('ServerScriptService')
local Systems = ServerS.Systems
local Ability = Systems.Ability
local AbilityStatus = require(Ability.Status)

local RepS = game:GetService('ReplicatedStorage')
local Packages = RepS.Packages
local Trove = require(Packages.Trove)

local WeaponName = script.Parent.Parent.Name

local Normal = {
    Status = AbilityStatus.Open
}

function Normal.Start(Battle, Ability, PlayerData)
    Battle.Status:Set(AbilityStatus.Locked)

    --> Unequip Previous Active Weapon
    local ActiveWeapon = Battle.ActiveWeapon
    if not ActiveWeapon then
        ActiveWeapon = {}
    else
        ActiveWeapon.Trove:Clean()
        if ActiveWeapon.Name == WeaponName then
            Battle.Status:Set(AbilityStatus.Open)
            return
        end
    end

    task.wait(.5)

    --> Setting New ActiveWeapon Data
    ActiveWeapon.Name = WeaponName
    
    --> Keeping Cleanup Ready For Future Equips
    ActiveWeapon.Trove = Trove.new()
    ActiveWeapon.Trove:Add(function()
        Battle.ActiveWeapon = nil
    end)
    Battle.ActiveWeapon = ActiveWeapon

    Battle.Status:Set(AbilityStatus.Open)
end

return Normal