local ShiftLockScreenGui = Instance.new("ScreenGui")
local ShiftLockButton = Instance.new("ImageButton")
local ShiftlockCursor = Instance.new("ImageLabel")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local TweenService = game:GetService("TweenService")
local CurrentTween = nil
local States = {
    Off = "rbxasset://textures/ui/mouseLock_off@2x.png",
    On = "rbxasset://textures/ui/mouseLock_on@2x.png",
    Lock = "rbxasset://textures/MouseLockedCursor.png",
    Lock2 = "rbxasset://SystemCursors/Cross"
}
local MaxLength = 900000
local EnabledOffset = CFrame.new(1.7, 0, 0)
local DisabledOffset = CFrame.new(-1.7, 0, 0)
local Active = nil

ShiftLockScreenGui.Name = "Shiftlock (CoreGui)"
ShiftLockScreenGui.Parent = CoreGui
ShiftLockScreenGui.IgnoreGuiInset = true
ShiftLockScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ShiftLockScreenGui.ResetOnSpawn = false

ShiftLockButton.Parent = ShiftLockScreenGui
ShiftLockButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ShiftLockButton.BackgroundTransparency = 1.000
ShiftLockButton.Position = UDim2.new(0.858712733, 0, 0.4985967, 0)
ShiftLockButton.Size = UDim2.new(0.0636147112, 0, 0.0661305636, 0)
ShiftLockButton.SizeConstraint = Enum.SizeConstraint.RelativeXX
ShiftLockButton.Image = States.Off

ShiftlockCursor.Name = "Shiftlock Cursor"
ShiftlockCursor.Parent = ShiftLockScreenGui
ShiftlockCursor.Image = "rbxassetid://74545890929478"
ShiftlockCursor.Size = UDim2.new(0.03, 0, 0.03, 0)
ShiftlockCursor.Position = UDim2.new(0.5, 0, 0.5, 0)
ShiftlockCursor.AnchorPoint = Vector2.new(0.5, 0.5)
ShiftlockCursor.SizeConstraint = Enum.SizeConstraint.RelativeXX
ShiftlockCursor.BackgroundTransparency = 1
ShiftlockCursor.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
ShiftlockCursor.Visible = false


local function ShiftLock()
    local Camera = workspace.CurrentCamera
    local Character = Player.Character or Player.CharacterAdded:Wait()
    local Humanoid = Character:WaitForChild("Humanoid")
    local HRP = Character:FindFirstChild("HumanoidRootPart")
    if not Active then
        Active = RunService.RenderStepped:Connect(function()
            local LookVector = Camera.CFrame.lookVector
            Humanoid.AutoRotate = false
            ShiftLockButton.Image = States.On
            ShiftlockCursor.Visible = true
            HRP.CFrame = CFrame.new(HRP.Position, HRP.Position + Vector3.new(LookVector.X, 0, LookVector.Z))
            Camera.CFrame = Camera.CFrame * EnabledOffset
        end)
    else
        Humanoid.AutoRotate = true
        ShiftLockButton.Image = States.Off
        ShiftlockCursor.Visible = false
        Camera.CFrame = Camera.CFrame * DisabledOffset
        pcall(function()
            Active:Disconnect()
            Active = nil
        end)
    end
end

ShiftLockButton.MouseButton1Click:Connect(ShiftLock)
local ShiftLockAction = ContextActionService:BindAction("Shift Lock", ShiftLock, false, "On")
ContextActionService:SetPosition("Shift Lock", UDim2.new(0.8, 0, 0.8, 0))

return {} and ShiftLockAction