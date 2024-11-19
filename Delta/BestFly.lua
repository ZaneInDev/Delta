--[[
FE Mobile Fly By Fedoratum#6195

Type in chat !stop, to stop the script
]]--

local StarterGui = game:GetService("StarterGui")

if game:GetService("ReplicatedStorage"):FindFirstChild("BZn2q91BzN") then
    StarterGui:SetCore("SendNotification", {
        Title = "FED's Mobile Fly",
        Text = "Script is already running",
        Icon = "rbxassetid://278315432",
        Duration = 4
    })
    return
end

local ScreenGui = Instance.new("ScreenGui")
local FlyButton = Instance.new("TextButton")
local SpeedBox = Instance.new("TextBox")

local NSound = Instance.new("Sound", FlyButton)
NSound.SoundId = "rbxassetid://9086208751"
NSound.Volume = 1

function Notify(Text, Duration)
    StarterGui:SetCore("SendNotification", {
        Title = "FED's Mobile Fly",
        Text = Text,
        Icon = "rbxassetid://278315432",
        Duration = Duration
    })
    NSound:Play()
end

-- Detect if script already ran
local VdbwjS = Instance.new("StringValue", game:GetService("ReplicatedStorage"))
VdbwjS.Name = "BZn2q91BzN"

Notify("Script made by fedoratum", 5)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local buttonIsOn = false

ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

FlyButton.Name = "FlyButton"
FlyButton.Parent = ScreenGui
FlyButton.BackgroundColor3 = Color3.new(0.168627, 0.513726, 0.25098)
FlyButton.BorderColor3 = Color3.new(0, 0, 0)
FlyButton.Position = UDim2.new(0.912970064, 0, 0.194202876, 0)
FlyButton.Size = UDim2.new(0, 50, 0, 50)
FlyButton.Font = Enum.Font.Code
FlyButton.Text = "Fly"
FlyButton.TextColor3 = Color3.new(0, 0, 0)
FlyButton.TextSize = 14
FlyButton.TextStrokeColor3 = Color3.new(1, 1, 1)
FlyButton.TextWrapped = true
FlyButton.Transparency = 0.2
FlyButton.Active = true
FlyButton.Draggable = true

SpeedBox.Name = "SpeedBox"
SpeedBox.Parent = FlyButton
SpeedBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SpeedBox.Position = UDim2.new(-1.716970064, 0, 0.004202876, 0)
SpeedBox.Size = UDim2.new(0, 80, 0, 50)
SpeedBox.Font = Enum.Font.Code
SpeedBox.PlaceholderText = "Speed"
SpeedBox.Text = ""
SpeedBox.TextColor3 = Color3.fromRGB(0, 0, 0)
SpeedBox.TextScaled = true
SpeedBox.TextSize = 14.000
SpeedBox.TextWrapped = true

local controlModule = require(LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule"))

local BodyVelocity = Instance.new("BodyVelocity")
BodyVelocity.Name = "VelocityHandler"
BodyVelocity.Parent = LocalPlayer.Character.HumanoidRootPart
BodyVelocity.MaxForce = Vector3.new(0, 0, 0)
BodyVelocity.Velocity = Vector3.new(0, 0, 0)

local BodyGyro = Instance.new("BodyGyro")
BodyGyro.Name = "GyroHandler"
BodyGyro.Parent = LocalPlayer.Character.HumanoidRootPart
BodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
BodyGyro.P = 1000
BodyGyro.D = 50

local Signal1
Signal1 = LocalPlayer.CharacterAdded:Connect(function(NewCharacter)
    local BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.Name = "VelocityHandler"
    BodyVelocity.Parent = NewCharacter:WaitForChild("Humanoid").RootPart
    BodyVelocity.MaxForce = Vector3.new(0, 0, 0)
    BodyVelocity.Velocity = Vector3.new(0, 0, 0)

    local BodyGyro = Instance.new("BodyGyro")
    BodyGyro.Name = "GyroHandler"
    BodyGyro.Parent = NewCharacter:WaitForChild("Humanoid").RootPart
    BodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    BodyGyro.P = 1000
    BodyGyro.D = 50
end)

local Camera = Workspace.CurrentCamera
local speed = 50

-- Create the Animation object
local ContextActionService = game:GetService("ContextActionService")
local UIS = game:GetService('UserInputService')

-- Key Bindings
local AscendKey = Enum.KeyCode.Space
local DescendKey = Enum.KeyCode.LeftShift

local flyAnimation = Instance.new("Animation")
flyAnimation.AnimationId = "rbxassetid://12518152696"

local animationTrack = LocalPlayer.Character.Humanoid:LoadAnimation(flyAnimation)

local function Ascend()
    if buttonIsOn then
        LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(LocalPlayer.Character.HumanoidRootPart.Velocity.X, 50, LocalPlayer.Character.HumanoidRootPart.Velocity.Z)
    end
end

-- Function to descend
local function Descend()
    if buttonIsOn then
        LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(LocalPlayer.Character.HumanoidRootPart.Velocity.X, -50, LocalPlayer.Character.HumanoidRootPart.Velocity.Z)
    end
end

local function HandleAscend(name, state, input)
    if state == Enum.UserInputState.Begin then
        Ascend()
    end
end

-- Function to Handle descending
local function HandleDescend(name, state, input)
    if state == Enum.UserInputState.Begin then
        Descend()
    end
end

UIS.InputBegan:Connect(function(key, gameProcessed)
    if gameProcessed then
        return
    end
    if key.KeyCode == AscendKey then 
        Ascend()
    elseif key.KeyCode == AscendKey then
        Descend()
    end
end)


-- Bind actions to ContextActionService
ContextActionService:BindAction("Ascend", HandleAscend, true, AscendKey)
ContextActionService:SetPosition("Ascend", UDim2.new(.2, 0, .3, 0))
ContextActionService:SetTitle("Ascend", "Ascend")

ContextActionService:BindAction("Descend", HandleDescend, true, DescendKey)
ContextActionService:SetPosition("Descend", UDim2.new(.2, 0, .5, 0))
ContextActionService:SetTitle("Descend", "Descend")

-- Prevent moving on Y-axis
Signal2 = RunService.RenderStepped:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and LocalPlayer.Character.Humanoid.RootPart and LocalPlayer.Character.HumanoidRootPart:FindFirstChild("VelocityHandler") and LocalPlayer.Character.HumanoidRootPart:FindFirstChild("GyroHandler") then
        if buttonIsOn then
            FlyButton.Text = "Fly: On"
            FlyButton.BackgroundColor3 = Color3.new(0, 255, 0)
            LocalPlayer.Character.HumanoidRootPart.VelocityHandler.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            LocalPlayer.Character.HumanoidRootPart.GyroHandler.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            LocalPlayer.Character.Humanoid.PlatformStand = true
        else
            FlyButton.Text = "Fly: Off"
            FlyButton.BackgroundColor3 = Color3.new(255, 0, 0)
            LocalPlayer.Character.HumanoidRootPart.VelocityHandler.MaxForce = Vector3.new(0, 0, 0)
            LocalPlayer.Character.HumanoidRootPart.GyroHandler.MaxTorque = Vector3.new(0, 0, 0)
            LocalPlayer.Character.Humanoid.PlatformStand = false
            animationTrack:Stop() -- Stop the animation if fly mode is off
            return
        end

        -- Maintain current Y position while allowing ascend/descend
        LocalPlayer.Character.HumanoidRootPart.GyroHandler.CFrame = CFrame.new(LocalPlayer.Character.HumanoidRootPart.Position) * CFrame.Angles(0, select(2, Camera.CoordinateFrame:ToEulerAnglesYXZ()), 0)

        local direction = controlModule:GetMoveVector()
        LocalPlayer.Character.HumanoidRootPart.VelocityHandler.Velocity = Vector3.new(0, 0, 0) -- Resetting velocity to prevent unintended movement

        if direction.X ~= 0 or direction.Z ~= 0 then
            if not animationTrack.IsPlaying then
                animationTrack:Play()
            end
        else
            if animationTrack.IsPlaying then
                animationTrack:Stop()
            end
        end

        -- Allow movement only on the X and Z axes
        -- Get the right and forward vectors without Y
        local RightVector = Vector3.new(Camera.CFrame.RightVector.X, 0, Camera.CFrame.RightVector.Z).Unit
        local LookVector = Vector3.new(Camera.CFrame.LookVector.X, 0, Camera.CFrame.LookVector.Z).Unit
        
        if direction.X > 0 then
            LocalPlayer.Character.HumanoidRootPart.VelocityHandler.Velocity = 
                LocalPlayer.Character.HumanoidRootPart.VelocityHandler.Velocity + RightVector * (direction.X * speed)
        elseif direction.X < 0 then
            LocalPlayer.Character.HumanoidRootPart.VelocityHandler.Velocity = 
                LocalPlayer.Character.HumanoidRootPart.VelocityHandler.Velocity + RightVector * (direction.X * speed)
        end
        
        if direction.Z > 0 then
            LocalPlayer.Character.HumanoidRootPart.VelocityHandler.Velocity = 
                LocalPlayer.Character.HumanoidRootPart.VelocityHandler.Velocity - LookVector * (direction.Z * speed)
        elseif direction.Z < 0 then
            LocalPlayer.Character.HumanoidRootPart.VelocityHandler.Velocity = 
                LocalPlayer.Character.HumanoidRootPart.VelocityHandler.Velocity - LookVector * (direction.Z * speed)
        end
    end
end)

-- Add mobile controls for ascend and descend
FlyButton.TouchTap:Connect(function()
    buttonIsOn = not buttonIsOn
end)

local Signal3
Signal3 = SpeedBox:GetPropertyChangedSignal("Text"):Connect(function()
    if tonumber(SpeedBox.Text) then
        speed = tonumber(SpeedBox.Text)
    end
end)

LocalPlayer.Chatted:Connect(function(msg)
    if msg:sub(1, 5) == "!stop" then
        Signal1:Disconnect()
        Signal2:Disconnect()
        Signal3:Disconnect()
        game:GetService("ReplicatedStorage"):FindFirstChild("BZn2q91BzN"):Destroy()
        ScreenGui:Destroy()
        LocalPlayer.Character.Humanoid.Health = 0
    end
end)
