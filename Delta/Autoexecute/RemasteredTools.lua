local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Hotbar = CoreGui.RobloxGui.Backpack.Hotbar
local Inventory = CoreGui.RobloxGui.Backpack.Inventory.ScrollingFrame.UIGridFrame

local Configuration = {
    TweenDuration = 0.3,
    Equipping = {
        Offset = Vector2.new(0, 0)  
    },
    Unequipping = {
        Offset = Vector2.new(0, -1)  
    }
}

local function Redesign(Bar)
    local UICorner = Instance.new("UICorner")
    local UIStroke = Instance.new("UIStroke")
    local UIGradient = Instance.new("UIGradient")
    
    UICorner.CornerRadius = UDim.new(1, 0)
    
    UIStroke.Color = Color3.fromRGB(255, 255, 255)
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    
    UIGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 255))})
    UIGradient.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.5), NumberSequenceKeypoint.new(1, 0)})
    UIGradient.Offset = Configuration.Unequipping.Offset
    UIGradient.Rotation = -90

    UICorner.Parent = Bar
    UIStroke.Parent = Bar
    UIGradient.Parent = UIStroke
    
    local CurrentTween = nil
    
    local function TweenUIGradient(NewOffset)
        if CurrentTween and not CurrentTween.Completed then
            CurrentTween:Cancel()
        end
        
        local TweenInfo = TweenInfo.new(Configuration.TweenDuration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local TweenProperties = {
            Offset = NewOffset
        }
        
        CurrentTween = TweenService:Create(UIGradient, TweenInfo, TweenProperties)
        CurrentTween:Play()
    end

    Bar.ChildAdded:Connect(function(Child)
        if Child.Name == "Equipped" then
            Child.Visible = false
            TweenUIGradient(Configuration.Equipping.Offset)
        end
    end)
    
    Bar.ChildRemoved:Connect(function(Child)
        if Child.Name == "Equipped" then
            TweenUIGradient(Configuration.Unequipping.Offset)
        end
    end)
end

local function Apply(Element)
    for _, Bar in pairs(Element:GetChildren()) do
        if string.match(Bar.Name, "^%d$") then
            Redesign(Bar)
        end
    end
    Element.ChildAdded:Connect(function(Child)
        if string.match(Child.Name, "^%d$") then
            Redesign(Child)
        end
    end)
end

Apply(Hotbar)
Apply(Inventory)
