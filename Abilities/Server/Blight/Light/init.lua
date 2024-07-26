local Light = {
    StartMove = 'Charge'
}

local WeaponName = script.Parent.Name

function Light.Trigger(Battle, PlayerData)
    local ActiveWeapon = Battle.ActiveWeapon
    if ActiveWeapon and ActiveWeapon.Name == WeaponName then
        --> Check cooldowns or whatever
        return true
    end
    return false
end

return Light