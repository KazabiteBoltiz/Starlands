local RepS = game:GetService('ReplicatedStorage')

local Packages = RepS.Packages
local Trove = require(Packages.Trove)
local Tree = require(Packages.Tree)

local Modules = RepS.Modules
local Value = require(Modules.Value)
local Spark = require(Modules.Spark)

local ServerS = game:GetService('ServerScriptService')
local Systems = ServerS.Systems
local Ability = require(Systems.Ability)
local AbilityStatus = require(Systems.Ability.Status)
local Abilities = ServerS.Abilities

--[[====================]]--

local Battle = {}
Battle.__index = Battle

--> Stores ([Character] => BattleObject) pairs
Battle.Instances = {} 

--[[
    Battle Object 

    -> Unequip abilities are too much, a simple 
    clean up will do.
    -> Weapon Data must be available, such as
    Combo, LastHit.
    -> Weapon Data should only be cleared when the 
    player loses the weapon from the inventory.
    Unequip should NOT wipe weapon data.
    -> If a weapon is equipped and then an ability
    is activated, then re-equip that weapon after.
    
]]

--[[
    self.Equipped = {
        Equip = EquipModule
        Unequip = UnequipModule
    }
]]

local function GetAbilityFromPath(abilityPath)
    if Tree.Exists(Abilities, abilityPath) then
        return Tree.Find(Abilities, abilityPath)
    end
end

function Battle.new(Character : Model, AbilityPaths : table)
    local self = setmetatable({}, Battle)

    self.Trove = Trove.new()

    self.Abilities = {}
    for _, abilityPath in AbilityPaths do
        self:Add(abilityPath)
    end

    self.Ability = Value.new(nil)
    self.Ability.SetTo:Connect(function(oldAbilityName, newAbilityName)
        print(`[Ability] {oldAbilityName} -> {newAbilityName}`)
    end)

    self.ActiveWeapon = nil
    self.Status = Value.new(AbilityStatus.One)

    Battle.Instances[Character] = self

    return self
end

function Battle:Add(abilityPath)
    local abilityModule = GetAbilityFromPath(abilityPath)
    if abilityModule then
        self.Abilities[abilityPath] = abilityModule
    end
end

function Battle:Remove(abilityPath)
    if self.Abilities[abilityPath] then
        self.Abilities[abilityPath] = nil
    end
end

function Battle:Get(Actor)
    if Actor:IsA('Model') then
        return Battle.Instances[Actor]
    elseif Actor:IsA('Player') then
        local Character = Actor.Character
        local Humanoid = Character:FindFirstChild('Humanoid')
        if not Humanoid or Humanoid.Health == 0 then
            return
        end
        return Battle.Instances[Character]
    end
end

function Battle:Activate(AbilityPath, PlayerData, StartMoveName)

    --> Check if ability exists
    local AbilityContainer = self.Abilities[AbilityPath]
    if not AbilityContainer then return end

    --> Trigger Check
    local AbilityData = require(AbilityContainer)
    local TriggerSuccess = AbilityData.Trigger(
        self,
        PlayerData
    )
    if not TriggerSuccess then return end

    local StartMoveName = StartMoveName or AbilityData.StartMove
    if not StartMoveName then return end
    
    --> Getting Active Status
    local ActiveStatus = self.Status:Get() or AbilityStatus.Open
    
    --> Status Comparison
    local StartMove = AbilityContainer:FindFirstChild(StartMoveName)
    local StartStatus = require(StartMove).Status
    if ActiveStatus.Value > StartStatus.Value then
        return
    end

    --> Initiate Ability
    self.Ability:Set(AbilityPath)

    Ability.new(
        self,
        PlayerData,
        AbilityContainer,
        StartMoveName
    )
end

function Battle:GetWeapon()

end

function Battle:Announce(Character, VisualPath, Event)
    local data = {
        'Ability',
        Character,
        VisualPath,
        Event
    }
end

function Battle:Destroy()
    Battle.Instances[self.Character] = nil
    self.Trove:Clean()
end

return Battle
