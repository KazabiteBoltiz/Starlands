local RepS = game:GetService('ReplicatedStorage')
local Modules = RepS.Modules
local Spark = require(Modules.Spark)

local CAS = game:GetService('ContextActionService')

local AbilityRequest = Spark.Event('AbilityRequest')

local Keybinds = {
    [Enum.KeyCode.Q] = 'FlashStep'
}

local function GetCharacterData()
    
end

local function SetupKeybinds()
    for abilityInput, abilityPath in Keybinds do
        CAS:BindAction(
            abilityPath,
            function(actionName, input)
                if actionName == abilityPath 
                    and input == Enum.UserInputState.Begin
                then
                    AbilityRequest:Fire(abilityPath, {})
                end
            end,
            false,
            abilityInput
        )
    end
end

SetupKeybinds()