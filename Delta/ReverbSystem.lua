local Sounds = game:GetService('SoundService')
local Players = game:GetService('Players')
local Workspace = game:GetService('Workspace')
local Debris = game:GetService('Debris')
local RunService = game:GetService('RunService')
local Player = Players.LocalPlayer

local Settings = { Rays = 20, Visualize = false, Type = "Global", Length = 20, Fallback = "NoReverb", IgnoreWater = true }
local MatSettings = {
    ["Fabric"] = Enum.ReverbType.NoReverb,
    ["Grass"] = Enum.ReverbType.Forest,
    ["Sand"] = Enum.ReverbType.Forest,
    ["SmoothPlastic"] = Enum.ReverbType.SewerPipe
}

local Rand = math.random
local Vect = Vector3.new

local function GetOrCreateReverbEffect(Sound)
    if Sound:IsA("Sound") then
        local ExistingReverb = Sound:FindFirstChildOfClass("ReverbSoundEffect")
        if ExistingReverb then
            return ExistingReverb
        end
        local Reverb = Instance.new("ReverbSoundEffect")
        Reverb.Parent = Sound
        return Reverb
    end
    return nil
end

local function GenerateSphericalDirections(NumDirections)
    local Directions = {}
    local GoldenRatio = (1 + math.sqrt(5)) / 2
    local AngleIncrement = math.pi * (3 - math.sqrt(5))
    for I = 0, NumDirections - 1 do
        local Y = 1 - (I / (NumDirections - 1)) * 2
        local Radius = math.sqrt(1 - Y * Y)
        local Theta = AngleIncrement * I
        local X = math.cos(Theta) * Radius
        local Z = math.sin(Theta) * Radius
        table.insert(Directions, Vector3.new(X, Y, Z))
    end
    return Directions
end

local function Reflect(RayDirection, SurfaceNormal)
    return RayDirection - 2 * (RayDirection:Dot(SurfaceNormal)) * SurfaceNormal
end

local function GetReverbPropertiesFromRaycast()
    local Character = Player and Player.Character
    if not Character then return nil end
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
    if not HumanoidRootPart then return nil end
    local Position = HumanoidRootPart.Position
    local RaycastParams = RaycastParams.new()
    RaycastParams.FilterType = Enum.RaycastFilterType.Whitelist
    RaycastParams.IgnoreWater = Settings.IgnoreWater
    RaycastParams.FilterDescendantsInstances = {Workspace, Character}
    local Directions = GenerateSphericalDirections(50)
    local Hits = {}
    local RayLength = 300
    local MinimumDistance = 10
    for _, Direction in ipairs(Directions) do
        local RaycastResult = Workspace:Raycast(Position, Direction * RayLength, RaycastParams)
        if RaycastResult then
            local Distance = (RaycastResult.Position - Position).magnitude
            if Distance > MinimumDistance then
                local SurfaceNormal = RaycastResult.Normal
                local ReflectedDirection = Reflect(Direction, SurfaceNormal)
                local ReflectedRaycastResult = Workspace:Raycast(RaycastResult.Position + SurfaceNormal * 0.1, ReflectedDirection * RayLength, RaycastParams)
                if ReflectedRaycastResult then
                    local ReflectedDistance = (ReflectedRaycastResult.Position - RaycastResult.Position).magnitude
                    if ReflectedDistance > MinimumDistance then
                        Distance = Distance + ReflectedDistance
                    end
                end
                Hits[Distance] = true
            end
        end
    end
    if next(Hits) then
        local SumOfDistances = 0
        for Distance in pairs(Hits) do
            SumOfDistances = SumOfDistances + Distance
        end
        local AverageDistance = SumOfDistances / #Hits
        local ReverbFactor = 100
        local DecayTime = math.clamp((AverageDistance / ReverbFactor), 0.1, 10)
        local Density = math.clamp(1 - (AverageDistance / ReverbFactor), 0.1, 1)
        local Diffusion = math.clamp(1 - (AverageDistance / ReverbFactor), 0.1, 1)
        return { DecayTime = DecayTime, Density = Density, Diffusion = Diffusion }
    end
    return nil
end

local function UpdateSoundReverb()
    local Properties = GetReverbPropertiesFromRaycast()
    for _, Sound in ipairs(Workspace:GetDescendants()) do
        if Sound:IsA("Sound") then
            local Reverb = GetOrCreateReverbEffect(Sound)
            if Reverb and Properties then
                Reverb.DecayTime = Properties.DecayTime
                Reverb.Density = Properties.Density
                Reverb.Diffusion = Properties.Diffusion
            end
        end
    end
end

local function Render()
    local Character = Player.Character
    local RootPart = Character:FindFirstChild('HumanoidRootPart')
    
    local RaycastParams = RaycastParams.new()
    RaycastParams.FilterDescendantsInstances = {Character}
    RaycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    RaycastParams.IgnoreWater = Settings.IgnoreWater

    local Length = Settings.Length
    local MatHits = {}

    for i = 1, Settings.Rays do
        local Dir = RootPart.Position + Vect(Rand(-Length, Length), Rand(-Length, Length), Rand(-Length, Length))
        local Result = Workspace:Raycast(RootPart.Position, Dir, RaycastParams)

        if Result then
            local MaterialName = Result.Material.Name
            MatHits[MaterialName] = (MatHits[MaterialName] or 0) + 1

            if Settings.Visualize then
                local DebugPart = Instance.new('Part')
                DebugPart.Material = Enum.Material.Neon
                DebugPart.BrickColor = BrickColor.Red()
                DebugPart.Size = Vect(0.1, 0.1, 0.1)
                DebugPart.CanCollide = false
                DebugPart.Position = Result.Position
                DebugPart.Parent = workspace

                Debris:AddItem(DebugPart, 0)
            end
        end
    end

    local HighestMaterial, HighestCount = nil, 0
    for MaterialName, Count in pairs(MatHits) do
        if Count > HighestCount then
            HighestMaterial = MaterialName
            HighestCount = Count
        end
    end

    local ReverbType = MatSettings[HighestMaterial]
    if ReverbType then
        Sounds.AmbientReverb = ReverbType
    else
        Sounds.AmbientReverb = Enum.ReverbType[Settings.Fallback]
    end
end

RunService.RenderStepped:Connect(function()
    Render()
    
end)

while task.wait(0.2) do
    UpdateSoundReverb()
end