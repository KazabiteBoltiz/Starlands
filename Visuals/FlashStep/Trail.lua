local RepS = game:GetService('ReplicatedStorage')
local Packages = RepS.Packages
local ReFX = require(Packages.ReFX)

local Modules = RepS.Modules
local GetPath = require(Modules.GetPath)

local Visuals = RepS.Visuals

local TrailEffect = ReFX.CreateEffect(
    GetPath(Visuals, script)
)

function TrailEffect:OnConstruct()
    self.DestroyOnEnd = false
    self.MaxLifetime = .3
end

function TrailEffect:OnStart(...)
    print('Trail Started!')
end

function TrailEffect:OnDestroy()
    print('Trail Destroyed.')
end

return TrailEffect