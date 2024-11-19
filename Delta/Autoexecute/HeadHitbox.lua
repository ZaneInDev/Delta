local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

_G.HeadSize = 15
_G.Enabled = true
_G.TeamCheck = true
_G.Invisible = false
_G.UseTeamColor = true
_G.DeathAnimation = true

_G.BoxEnabled = true
_G.BoxSize = Vector3.new(4, 6, 0)
_G.BoxColor = Color3.fromRGB(255, 170, 0)
_G.BoxThickness = 2
_G.TeamCheck = true
_G.UseTeamColor = true
_G.RenderInNil = false

local HeadSizeValue = Instance.new("NumberValue")
local EnabledValue = Instance.new("BoolValue")
local TeamCheckValue = Instance.new("BoolValue")
local InvisibleValue = Instance.new("BoolValue")
local UseTeamColorValue = Instance.new("BoolValue")

local BoxEnabledValue = Instance.new("BoolValue")
local BoxSizeValue = Instance.new("Vector3Value")
local BoxColorValue = Instance.new("Color3Value")
local BoxThicknessValue = Instance.new("NumberValue")
local TeamCheckValue = Instance.new("BoolValue")
local UseTeamColorValue = Instance.new("BoolValue")
local RenderInNilValue = Instance.new("BoolValue")


HeadSizeValue.Value = _G.HeadSize
EnabledValue.Value = _G.Enabled
TeamCheckValue.Value = _G.TeamCheck
InvisibleValue.Value = _G.Invisible
UseTeamColorValue.Value = _G.UseTeamColor

BoxEnabledValue.Value = _G.BoxEnabled
BoxSizeValue.Value = _G.BoxSize
BoxColorValue.Value = _G.BoxColor
BoxThicknessValue.Value = _G.BoxThickness
TeamCheckValue.Value = _G.TeamCheck
UseTeamColorValue.Value = _G.UseTeamColor
RenderInNilValue.Value = _G.RenderInNil

local function SyncGlobalVariables()
    HeadSizeValue.Value = _G.HeadSize
    EnabledValue.Value = _G.Enabled
    TeamCheckValue.Value = _G.TeamCheck
    InvisibleValue.Value = _G.Invisible
    UseTeamColorValue.Value = _G.UseTeamColor
    
    BoxEnabledValue.Value = _G.BoxEnabled
    BoxSizeValue.Value = _G.BoxSize
    BoxColorValue.Value = _G.BoxColor
    BoxThicknessValue.Value = _G.BoxThickness
    TeamCheckValue.Value = _G.TeamCheck
    UseTeamColorValue.Value = _G.UseTeamColor
    RenderInNilValue.Value = _G.RenderInNil
end

local function GetPlayers()
    for _, Player in ipairs(Players:GetPlayers()) do
        return Player
    end
end

local function GetHead(Character)
    local Head
    while task.wait() do
        for _, Part in ipairs(Character:GetChildren()) do
            if Part:IsA("BasePart") and Part.Name:lower() == "head" then
                Head = Part
                break 
            end
        end
        if Head then
            break 
        end
    end
    return Head 
end

local function CreateHeadPropertyObject(Player)
    local PropertyObject = Instance.new("Folder", ReplicatedStorage)
    PropertyObject.Name = Player.Name

    local SizeValue = Instance.new("Vector3Value", PropertyObject)
    SizeValue.Name = "Size"

    local BrickColorValue = Instance.new("BrickColorValue", PropertyObject)
    BrickColorValue.Name = "BrickColor"

    local TransparencyValue = Instance.new("NumberValue", PropertyObject)
    TransparencyValue.Name = "Transparency"

    local CanCollideValue = Instance.new("BoolValue", PropertyObject)
    CanCollideValue.Name = "CanCollide"

    local MasslessValue = Instance.new("BoolValue", PropertyObject)
    MasslessValue.Name = "Massless"

    return PropertyObject
end

local function SaveOriginalHeadProperties(Player)
    local Character = Player.Character or Player.CharacterAdded:Wait()
    if Character then
        local Head = GetHead(Character)
        if Head then
            local PropertyObject = ReplicatedStorage:FindFirstChild(Player.Name) or CreateHeadPropertyObject(Player)
            PropertyObject.Size.Value = Head.Size
            PropertyObject.BrickColor.Value = Head.BrickColor
            PropertyObject.Transparency.Value = Head.Transparency
            PropertyObject.CanCollide.Value = Head.CanCollide
            PropertyObject.Massless.Value = Head.Massless
        end
    end
end

local function DuplicateHead(Character)
    local OriginalHead = GetHead(Character)
    if not OriginalHead then return end

    
    local NewHead = OriginalHead:Clone()
    NewHead.Parent = Character
    NewHead.Name = "NewHead"  
    
    for _, Constraint in ipairs(Character:GetDescendants()) do
        if Constraint:IsA("Weld") or Constraint:IsA("WeldConstraint") or Constraint:IsA("Motor6D") then
            if Constraint.Part0 == OriginalHead then
                local NewConstraint = Constraint:Clone()
                NewConstraint.Parent = Constraint.Parent
                NewConstraint.Part0 = NewHead
                NewConstraint.Part1 = Constraint.Part1
            elseif Constraint.Part1 == OriginalHead then
                local NewConstraint = Constraint:Clone()
                NewConstraint.Parent = Constraint.Parent
                NewConstraint.Part1 = NewHead
                NewConstraint.Part0 = Constraint.Part0
            end
        end
    end
end

local function ApplyHeadModifications(Player)
    local Character = Player.Character or Player.CharacterAdded:Wait()
    if Character then
        local Head = GetHead(Character)
        if not Character:FindFirstChild("NewHead") then
            DuplicateHead(Character)
        end
        if Head then
            local Face = Head:FindFirstChildWhichIsA("Decal")
            if Face then
                Face.Transparency = 1
            end
            Head.Massless = true
            Head.Size = Vector3.new(HeadSizeValue.Value, HeadSizeValue.Value, HeadSizeValue.Value)
            Head.Transparency = InvisibleValue.Value and 1 or 0
            Head.BrickColor = (UseTeamColorValue.Value and Player.Team and Player.Team.TeamColor) or BrickColor.new("Red")
            Head.Material = InvisibleValue.Value and "Neon" or "ForceField"
            Head.CanCollide = false
        end
    end
end

local function RestoreHeadProperties(Player)
    local PropertyObject = ReplicatedStorage:FindFirstChild(Player.Name)
    if PropertyObject then
        local Character = Player.Character or Player.CharacterAdded:Wait()
        if Character then
            local Head = GetHead(Character)
            local DupHead = Character:FindFirstChild("NewHead")
            if DupHead then
                DupHead:Destroy()
            end
            if Head then
                local Face = Head:FindFirstChildWhichIsA("Decal")
                if Face then
                    Face.Transparency = 0
                end
                Head.Size = PropertyObject.Size.Value
                Head.BrickColor = PropertyObject.BrickColor.Value
                Head.Transparency = PropertyObject.Transparency.Value
                Head.Material = Enum.Material.Plastic
                Head.CanCollide = PropertyObject.CanCollide.Value
                Head.Massless = PropertyObject.Massless.Value
            end
        end
    end
end

local function DeathAnimationHandler(Head)
    if _G.DeathAnimation and Head then
        Head.CanQuery = false
        local TweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        local Goal = {Size = Vector3.new(0, 0, 0)}
        local Tween = TweenService:Create(Head, TweenInfo, Goal)

        Tween.Completed:Connect(function()
            Head.Size = Vector3.new(0, 0, 0)
        end)

        Tween:Play()
    end
end

local function UpdatePlayer(Player)
    if EnabledValue.Value then
        if not TeamCheckValue.Value or (Player.Team and Player.Team ~= Players.LocalPlayer.Team) then
            ApplyHeadModifications(Player)
        else
            RestoreHeadProperties(Player)
        end
    else
        RestoreHeadProperties(Player)
    end
end

local function UpdateAll()
    for _, Player in ipairs(Players:GetPlayers()) do
        if Player ~= Players.LocalPlayer and Player.Character then
            if EnabledValue.Value then
                if not TeamCheckValue.Value or (Player.Team and Player.Team ~= Players.LocalPlayer.Team) then
                    ApplyHeadModifications(Player)
                else
                    RestoreHeadProperties(Player)
                end
            else
                RestoreHeadProperties(Player)
            end
        end
    end
end

local function AttachPlayerEvents(Player)
    local function ConnectDeathEvent(Character)
        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
        if Humanoid then
            Humanoid.Died:Connect(function()
                local Head = GetHead(Character)
                DeathAnimationHandler(Head)
            end)
        end
    end

    Player.CharacterAdded:Connect(function(Character)
        SaveOriginalHeadProperties(Player)
        UpdatePlayer(Player)
        ConnectDeathEvent(Character) 
    end)

    if Player.Character then
        SaveOriginalHeadProperties(Player)
        UpdatePlayer(Player)
        ConnectDeathEvent(Player.Character) 
    end

    Player:GetPropertyChangedSignal("Team"):Connect(function()
        UpdatePlayer(Player)
    end)
end

local function InitializePlayerHandling()
    for _, Player in ipairs(Players:GetPlayers()) do
        if Player ~= Players.LocalPlayer then
            AttachPlayerEvents(Player)
        end
    end

    Players.PlayerAdded:Connect(AttachPlayerEvents)
    
    Players.LocalPlayer:GetPropertyChangedSignal("Team"):Connect(UpdateAll)
       
    Players.PlayerRemoving:Connect(function(Player)
        local PropertyObject = ReplicatedStorage:FindFirstChild(Player.Name)
        if PropertyObject then
            PropertyObject:Destroy()
        end
    end)
end

RunService.Heartbeat:Connect(SyncGlobalVariables)

HeadSizeValue.Changed:Connect(UpdateAll)
EnabledValue.Changed:Connect(UpdateAll)
TeamCheckValue.Changed:Connect(UpdateAll)
InvisibleValue.Changed:Connect(UpdateAll)
UseTeamColorValue.Changed:Connect(UpdateAll)

EnabledValue.Changed:Connect(UpdateAllPlayersEsp)
BoxSizeValue.Changed:Connect(UpdateAllPlayersEsp)
BoxColorValue.Changed:Connect(UpdateAllPlayersEsp)
BoxThicknessValue.Changed:Connect(UpdateAllPlayersEsp)
TeamCheckValue.Changed:Connect(UpdateAllPlayersEsp)
UseTeamColorValue.Changed:Connect(UpdateAllPlayersEsp)

InitializePlayerHandling()
print("head expander executed.")
