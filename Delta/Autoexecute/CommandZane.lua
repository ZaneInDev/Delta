local NotificationHolder = loadstring(game:HttpGet("https://raw.githubusercontent.com/BocusLuke/UI/main/STX/Module.Lua"))()
local Notification = loadstring(game:HttpGet("https://raw.githubusercontent.com/BocusLuke/UI/main/STX/Client.Lua"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local TeleportService = game:GetService("TeleportService")
local CurrentPlaceId = game.PlaceId
local GameName = MarketplaceService:GetProductInfo(CurrentPlaceId).Name 
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local IsActive = true
local MifyuOnly = false
local BlacklistedPlayers = {}
local PriorFriendsOnly = false
local NotifyChatEnabled = true

local AimbotEnabled = false
local TeamCheckEnabled = true
local WallCheckEnabled = true
local SmoothenEnabled = false
local ClosestPosition = false
local IgnoreFriends = false
local PredictMovements = false
local AimPart = "Head"
local AlliesTable = {}
local InputPlayer = nil
local Offset = 0
local PredictDistance = 3
local TargetLoop

--[[// ESP
local EspEnabled = true
local Tracers = true
local Names = true
local Boxes = true
local Highlights = true
local TracersTable = {}
local NamesTable = {}
local BoxesTable = {}
local HighlightsTable = {}
]]

local BadWordsList = {['getlost'] = 'Bullying', ['f4'] = 'Swearing', ['🤓'] = 'Bullying', ['gay'] = 'Bullying', ['trans'] = 'Bullying', ['lgbt'] = 'Bullying', ['lesbian'] = 'Bullying', ['suicide'] = 'Bullying', ['cum'] = 'Swearing', ['f@g0t'] = 'Bullying', ['cock'] = 'Swearing', ['penis'] = 'Swearing', ['furry'] = 'Bullying', ['furries'] = 'Bullying', ['dick'] = 'Swearing', ['nigger'] = 'Bullying', ['bible'] = 'Bullying', ['nigga'] = 'Bullying', ['cheat'] = 'Scamming', ['report'] = 'Bullying', ['niga'] = 'Bullying', ['bitch'] = 'Bullying', ['sex'] = 'Swearing', ['cringe'] = 'Bullying', ['trash'] = 'Bullying', ['allah'] = 'Bullying', ['dumb'] = 'Bullying', ['idiot'] = 'Bullying', ['kid'] = 'Bullying', ['clown'] = 'Bullying', ['bozo'] = 'Bullying', ['faggot'] = 'Bullying', ['fagg'] = 'Bullying', ['fag'] = 'Bullying', ['autistic'] = 'Bullying', ['autism'] = 'Bullying', ['getalife'] = 'Bullying', ['nolife'] = 'Bullying', ['nolife'] = 'Bullying', ['adopted'] = 'Bullying', ['skillissue'] = 'Bullying', ['muslim'] = 'Bullying', ['gender'] = 'Bullying', ['parent'] = 'Bullying', ['islam'] = 'Bullying', ['christian'] = 'Bullying', ['noob'] = 'Bullying', ['retard'] = 'Bullying', ['burn'] = 'Bullying', ['stupid'] = 'Bullying', ['wthf'] = 'Swearing', ['pride'] = 'Bullying', ['mother'] = 'Bullying', ['father'] = 'Bullying', ['homo'] = 'Bullying', ['hate'] = 'Bullying', ['exploit'] = 'Scamming', ['hack'] = 'Scamming', ['download'] = 'Scamming', ['youtube'] = 'OffsiteLinks', ['micup'] = 'Bullying', ['sthu'] = 'Bullying', ['khord'] = 'OffsiteLinks', ['tt'] = 'OffsiteLinks', ['adoptmesextape'] = 'Swearing', ['furrysexwatcher'] = 'Swearing', ['esex'] = 'Swearing', ['prisonsex'] = 'Swearing', ['🌊ock'] = 'Swearing', ['head'] = 'Swearing', ['ugly'] = 'Bullying', ['suck'] = 'Swearing', ['die'] = 'Bullying', ['smelly'] = 'Bullying', ['inches'] = 'Swearing', ['jerk'] = 'Swearing', ['kys'] = 'Bullying', ['kill'] = 'Swearing', ['moan'] = 'Swearing', ['whimper'] = 'Swearing', ['kick'] = 'Bullying', ['btc'] = 'Swearing'}
local AutoReportEnabled = false
local Filter = false
local Cooldown = false
local AutoReportNotify = true
local TargetPlayer = nil -- Change this to the player's name you want to target
local TargetOnePlayer = false -- Set to true to target one player, false for global reporting
local InCooldown = false

local FolderName = "Servers"
local GameFolder = FolderName .. "/" .. GameName:gsub(" ", "")

local AnimationInstance = Instance.new("Animation")
AnimationInstance.AnimationId = "rbxassetid://698251653"

local AnimationIds = { ["Crazy Slash"] = 674871189, ["Open"] = 582855105, ["R15 Spinner"] = 754658275, ["Arms Out"] = 582384156, ["Float Slash"] = 717879555, ["Weird Zombie"] = 708553116, ["Down Slash"] = 746398327, ["Pull"] = 675025795, ["Circle Arm"] = 698251653, ["Bend"] = 696096087, ["Rotate Slash"] = 675025570, ["Fling Arms"] = 754656200 }
local Presets = {
    ["Hug"] = {14366558676, 17172918855, 708553116}
}

local AnimationTrack
local PlaybackSpeed1 = 0
local PlaybackSpeed2 = 0.5
local CurrentPlayback = 0
local IsAnimationLooping = false
local Instances = {}
local TweenInstance, TweenCompleted
local IsReversed = false

local function CancelTween()
    if TweenInstance then
        TweenInstance:Cancel()
        TweenInstance = nil
    end
    if TweenCompleted then
        TweenCompleted:Disconnect()
        TweenCompleted = nil
    end
end

local function UpdateAnimationId(SelectedAnimation)
    if AnimationIds[SelectedAnimation] then
        AnimationInstance.AnimationId = "rbxassetid://" .. AnimationIds[SelectedAnimation]
    end
end

local function PlayAnimation()
    if AnimationTrack then
        AnimationTrack:Stop()
    end
    AnimationTrack = LocalPlayer.Character:FindFirstChild("Humanoid"):LoadAnimation(AnimationInstance)
    AnimationTrack.Looped = true
    AnimationTrack:Play(0.1, 1, PlaybackSpeed1)
    AnimationTrack.TimePosition = CurrentPlayback
end

local function SetSpeed(Input)
    if AnimationTrack then
        if IsAnimationLooping then
            AnimationTrack:AdjustSpeed(0)
            PlaybackSpeed2 = tonumber(Input or PlaybackSpeed2)
            print(Input)
        else
            AnimationTrack:AdjustSpeed(tonumber(Input) or PlaybackSpeed1) 
            PlaybackSpeed1 = tonumber(Input) or PlaybackSpeed1
            print(Input)
        end
    end
end

local function AdjustPlayback(Input)
    CurrentPlayback = tonumber(Input) or CurrentPlayback
    if AnimationTrack then
        AnimationTrack.TimePosition = CurrentPlayback
    end
end

local function TweenTimePosition(StartPosition, EndPosition)
    local TweenInfo = TweenInfo.new(PlaybackSpeed2, Enum.EasingStyle.Linear)
    TweenInstance = TweenService:Create(AnimationTrack, TweenInfo, {TimePosition = EndPosition})
    TweenInstance:Play()

    TweenCompleted = TweenInstance.Completed:Connect(function()
        IsReversed = not IsReversed
        TweenTimePosition(IsReversed and EndPosition or StartPosition, IsReversed and StartPosition or EndPosition)
    end)
end

local function HandleInputForAB(Input)
    local TimeValues = {}
    for Number in string.gmatch(Input, "[^%s%-]+") do
        table.insert(TimeValues, tonumber(Number))
    end
    if #TimeValues == 2 then
        local Start, End = TimeValues[1], TimeValues[2]
        IsAnimationLooping = true
        CancelTween()
        AnimationTrack:AdjustSpeed(0)
        TweenTimePosition(Start, End)
    else
        IsAnimationLooping = false
        CancelTween()
        if AnimationTrack then AnimationTrack:AdjustSpeed(1) end
        print("Invalid input, expected format: A - B")
    end
end

local function Notify(NotificationTable)
    Notification:Notify(
        {Title = NotificationTable.Title, Description = NotificationTable.Description},
        {OutlineColor = Color3.fromRGB(80, 80, 80), Time = NotificationTable.Duration, Type = "default"}
    )
end

local function IsEnemy(Player)
    if Player.Team ~= LocalPlayer.Team then
        return true
    else
        return false
    end
end

local function GetPlayerName(Player)
    if Player then
        local DisplayName = Player.DisplayName
        local Name = Player.Name
        
        if DisplayName ~= Name then
            return string.format("%s ( %s )", DisplayName, Name)
        else 
            return Name
        end
    end
    return nil
end

local function IsPlayerListed(Table, Player)
    for _, Target in ipairs(Table) do
        if Target == Player then
            return true
        end
    end
    return false
end

local function IsFriendOfLocalPlayer(Player)
    return LocalPlayer:IsFriendsWith(Player.UserId)
end

local function ShowNotification(Action, Player)
    local NotificationText = nil
    
    if Action == "blacklist_found" then
        NotificationText = " has been blacklisted."
    elseif Action == "blacklist_done" then
        NotificationText = " is already blacklisted."
    elseif Action == "whitelist_found" then
        NotificationText = " has been removed from the blacklist."
    elseif Action == "whitelist_not" then
        NotificationText = " is not blacklisted."
    elseif Action == "not_found" then
        if Player then
            NotificationText = "Player '" .. Player .. "' not found."
        else
            NotificationText = "Player not found."
        end
    elseif Action == "blacklist_cleared" then
        NotificationText = "The blacklist has been cleared."
    end
    
    local PlayerInfo = GetPlayerName(Player) 
    
    local NotificationTable = {
        Title = "Blacklist System",
        Text = (PlayerInfo and PlayerInfo .. " " or "") .. (NotificationText or ""),
        Duration = 5
    }
    
    Notify({
        Description = NotificationTable.Text,
        Title = NotificationTable.Title,
        Duration = NotificationTable.Duration
    })
    
    if NotifyChatEnabled then
        local ChatMessage = "[Blacklist System]: " .. NotificationTable.Text
        ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(ChatMessage, "All")
    end
end

local function FindPlayerWithName(Name)
    for _, Player in ipairs(Players:GetPlayers()) do
        if Player.Name:lower():find(Name:lower()) or Player.DisplayName:lower():find(Name:lower()) then
            return Player
        end
    end
    return nil
end

local function RemoveFromTable(Table, Player)
    for i, Target in ipairs(Table) do
        if Target == Player then
            table.remove(Table, i)
            return
        end
    end
end

local function GetPart(PartName, Character)
    for _, Child in ipairs(Character:GetChildren()) do
        if Child:IsA("BasePart") and Child.Name:lower() == PartName:lower() then
            return Child
        end
    end
    return nil
end


local function LookAt(Target)
    local LookVector = (Target - Camera.CFrame.Position).unit
    local NewCFrame = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + LookVector)
    local TweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out) -- Adjust the tween duration and easing style as desired
    local Tween = game:GetService("TweenService"):Create(Camera, TweenInfo, {CFrame = NewCFrame})
    if not SmoothenEnabled then
        Camera.CFrame = NewCFrame
    else
        Tween:Play()
    end
end

local function PredictMovement(Player)
    local Character = Player.Character or Player.CharacterAdded:Wait()
    if Character and Character:FindFirstChild("HumanoidRootPart") then
        local RootPart = GetPart("HumanoidRootPart", Character)
        local Velocity = RootPart.Velocity
        local MoveDirection = Character:FindFirstChildWhichIsA("Humanoid").MoveDirection
        local FuturePosition = RootPart.Position + Velocity * 0.2 + MoveDirection * PredictDistance -- Modify the scalar values as needed
        return FuturePosition
    end
    return nil
end

local function GetVehicleModelFromSeat(SeatPart)
    local VehicleModel = SeatPart.Parent
    while VehicleModel and not VehicleModel:IsA("Model") do
        VehicleModel = VehicleModel.Parent
    end
    return VehicleModel
end

function GetVehicleModelFromSeat(SeatPart)
    local VehicleModel = SeatPart.Parent
    if VehicleModel and not VehicleModel:IsA("Model") then
        VehicleModel = VehicleModel.Parent
    end
    return VehicleModel
end

function GetClosestEnemyPlayer(TargetPart)
    local NearestPlayer = nil
    local LastDistance = math.huge

    local LocalCharacter = LocalPlayer.Character
    local Humanoid = LocalCharacter and LocalCharacter:FindFirstChildWhichIsA("Humanoid")
    
    local VehicleModel = nil
    if Humanoid and Humanoid.SeatPart then
        VehicleModel = GetVehicleModelFromSeat(Humanoid.SeatPart)
    end

    for _, Player in ipairs(Players:GetPlayers()) do
        local Character = Player.Character or Player.CharacterAdded:Wait()
        if Player ~= LocalPlayer and Character then
            local EnemyHumanoid = Character:FindFirstChildWhichIsA("Humanoid")
            if EnemyHumanoid and EnemyHumanoid.Health > 0 then
                local IsAllowed = not TeamCheckEnabled
                if TeamCheckEnabled and IsEnemy(Player) then
                    IsAllowed = true
                end

                if IsAllowed and not IsPlayerListed(AlliesTable, Player) and (not IgnoreFriends or not IsFriendOfLocalPlayer(Player)) then
                    local EnemyVehicleModel = nil
                    if Character and EnemyHumanoid then
                        if EnemyHumanoid and EnemyHumanoid.SeatPart then
                            EnemyVehicleModel = GetVehicleModelFromSeat(EnemyHumanoid.SeatPart)
                        end
                    end
                    if not ClosestPosition then
                        local AimObject = GetPart(TargetPart, Character) or GetPart("UpperTorso", Character)
                        if AimObject then
                            local EyePos, IsVisible = Camera:WorldToViewportPoint(AimObject.Position)
                            local AimPos = Vector2.new(EyePos.x, EyePos.y)
                            local MousePos = Vector2.new(Camera.ViewportSize.x / 2, Camera.ViewportSize.y / 2)
                            local Distance = (AimPos - MousePos).magnitude
                            if Distance < LastDistance and IsVisible then
                                if WallCheckEnabled then
                                    local RaycastParams = RaycastParams.new()
                                    RaycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
                                    if VehicleModel then
                                        table.insert(RaycastParams.FilterDescendantsInstances, VehicleModel)
                                    end
                                    if EnemyVehicleModel then
                                        table.insert(RaycastParams.FilterDescendantsInstances, EnemyVehicleModel)
                                    end
                                    RaycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                                    local Part = workspace:Raycast(Camera.CFrame.Position, (AimObject.Position - Camera.CFrame.Position).Unit * math.huge, RaycastParams)
                                    if Part and Part.Instance and Part.Instance:IsDescendantOf(Character) then
                                        LastDistance = Distance
                                        NearestPlayer = Player
                                    end
                                else
                                    if not VehicleModel or not AimObject:IsDescendantOf(VehicleModel) then
                                        LastDistance = Distance
                                        NearestPlayer = Player
                                    end
                                end
                            end
                        end
                    else
                        local LocalPlayerPosition = LocalPlayer.Character and LocalPlayer.Character.PrimaryPart and LocalPlayer.Character.PrimaryPart.Position
                        local TargetPosition = Character and Character.PrimaryPart and Character.PrimaryPart.Position
                        if LocalPlayerPosition and TargetPosition then
                            local Distance = (LocalPlayerPosition - TargetPosition).magnitude
                            if Distance < LastDistance then
                                if WallCheckEnabled then
                                    local Ray = Ray.new(LocalPlayerPosition, (TargetPosition - LocalPlayerPosition).Unit * 500)
                                    local RaycastParams = RaycastParams.new()
                                    RaycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
                                    if VehicleModel then
                                        table.insert(RaycastParams.FilterDescendantsInstances, VehicleModel)
                                    end
                                    if EnemyVehicleModel then
                                        table.insert(RaycastParams.FilterDescendantsInstances, EnemyVehicleModel)
                                    end
                                    RaycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                                    local Part = workspace:Raycast(Ray.Origin, Ray.Direction, RaycastParams)
                                    if Part and Part.Instance and Part.Instance:IsDescendantOf(Character) then
                                        LastDistance = Distance
                                        NearestPlayer = Player
                                    end
                                else
                                    if not VehicleModel or not TargetPosition:IsDescendantOf(VehicleModel) then
                                        LastDistance = Distance
                                        NearestPlayer = Player
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return NearestPlayer
end


function Report(Target, ReportString)
    if not Cooldown or not InCooldown then
        local PlayerInfo = GetPlayerName(Target)
        local NotificationText = string.format("Reported %s For Saying: '%s'", PlayerInfo, ReportString)
        local Success, Error = pcall(function()
            Players:ReportAbuse(Target, ReportString, ' : Breaking Terms Of Service Rules.')
        end)
        if not Success then
            return warn("Couldn't Report Due To: " .. Error .. ' | AR')
        else
            if not TargetOnePlayer or (not Filter and TargetPlayer ~= Target) then
                Notify({
                    Description = NotificationText,
                    Title = "AR | System",
                    Duration = 5
                })
            elseif Filter and TargetPlayer and TargetOnePlayer and TargetPlayer == Target then 
                print(PlayerInfo, "Reported For Saying:", ReportString)
            end
            
            if AutoReportNotify then
                local ChatMessage = "[AutoReport System]: " .. NotificationText
                ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(ChatMessage, "All")
            end
        end
        InCooldown = true
        task.wait(5)
        InCooldown = false
    end
end

local function AutoReportMessages(Target)
    Target.Chatted:Connect(function(Message)
        if Target ~= LocalPlayer then
            local LowerMessage = Message:lower()
            if AutoReportEnabled then
                if not TargetOnePlayer and (not TargetPlayer or Target ~= TargetPlayer) then
                    for Word, ReportString in next, BadWordsList do
                        if string.find(LowerMessage, Word) then
                            Report(Target, Message)
                        end
                    end
                elseif TargetOnePlayer and TargetPlayer and Target == TargetPlayer then
                    if not Filter then
                        Report(Target, Message)
                    else
                        for Word, ReportString in next, BadWordsList do
                            if string.find(LowerMessage, Word) then
                                Report(Target, Message)
                            end
                        end
                    end
                end
            end
        end
    end) 
end

-- Wizard UI Library Integration
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/ZaneInDev/ZaneMain/refs/heads/main/DrRay.lua"))()
local Window = Library:Load("Zane's Personal Panel", "Default")
local CallTab = Library.newTab("Call System", "ImageIdHere")
local AimbotTab = Library.newTab("Aimbot", "ImageIdHere")
local ReportTab = Library.newTab("Auto Report", "ImageIdHere")
local EspTab = Library.newTab("ESP", "ImageIdHere")
local AnimationsTab = Library.newTab("Animations", "ImageIdHere")

local function NotifyIfNeeded(Description, Title, NotifyOnChange)
    if NotifyOnChange then
        if not Title then
            Title = "Warning!"
        end
        Notify({
            Description = Description,
            Title = Title,
            Duration = 5
        })
    end
end

local function CreateToggle(Tab, Name, Description, DefaultState, Callback, NotifyOnChange)
    Tab.newToggle(Name, Description, DefaultState, function(Bool)
        Callback(Bool)
        NotifyIfNeeded(Name .. ": " .. (Bool and "Activated." or "Deactivated."), nil, NotifyOnChange)
    end)
end

local function CreateInput(Tab, Name, Description, Callback, NotifyOnChange)
    Tab.newInput(Name, Description, function(Text)
        Callback(Text)
        NotifyIfNeeded(Name .. ": " .. (Text ~= "" and "Updated." or "Cleared."), nil, NotifyOnChange)
    end)
end

local function CreateButton(Tab, Name, Description, Callback, NotifyOnChange)
    Tab.newButton(Name, Description, function()
        Callback()
        NotifyIfNeeded(Name .. ": Clicked.", nil, NotifyOnChange)
    end)
end

local function CreateSlider(Tab, Name, Description, Min, Max, IsManageable, Increment, Callback, NotifyOnChange)
    Tab.newSlider(Name, Description, Min, Max, IsManageable, Increment, function(Value)
        Callback(Value)
        NotifyIfNeeded(Name .. ": Set to " .. Value, nil, NotifyOnChange)
    end)
end

local function CreateDropdown(Tab, Name, Description, Options, Callback, NotifyOnChange)
    Tab.newDropdown(Name, Description, Options, function(Selected)
        Callback(Selected)
        NotifyIfNeeded(Name .. ": Selected " .. Selected, nil, NotifyOnChange)
    end)
end

CreateToggle(CallTab, "Call System", "Enables The System.", true, function(Bool)
    IsActive = Bool
end, true)

CreateToggle(CallTab, "Prioritize Friends", "Prioritize Your Friends.", false, function(Bool)
    PriorFriendsOnly = Bool
end, true)

CreateToggle(CallTab, "Mifyu Only", "Enables Mifyu Only Check.", false, function(Bool)
    MifyuOnly = Bool
end, true)

CreateToggle(CallTab, "Notify Chat", "Notifies The Chat.", false, function(Bool)
    NotifyChatEnabled = Bool
end, true)

CreateInput(CallTab, "Blacklist", "Blacklist's The Player From The System.", function(Text)
    local Player = FindPlayerWithName(Text)
    if Player then
        if not IsPlayerListed(BlacklistedPlayers, Player) then
            table.insert(BlacklistedPlayers, Player)
            ShowNotification("blacklist_found", Player)
        else
            ShowNotification("blacklist_done", Player)
        end
    else
        ShowNotification("not_found", Text)
    end
end, false)

CreateInput(CallTab, "Whitelist", "Whitelist's The Player From The System.", function(Text)
    local Player = FindPlayerWithName(Text)
    if Player then
        if IsPlayerListed(BlacklistedPlayers, Player) then
            RemoveFromTable(BlacklistedPlayers, Player)
            ShowNotification("whitelist_found", Player)
        else
            ShowNotification("whitelist_not", Player)
        end
    else
        ShowNotification("not_found", Text)
    end
end, false)

CreateButton(CallTab, "Clear Blacklist", "Clears The Blacklisted Players.", function()
    BlacklistedPlayers = {}
    ShowNotification("blacklist_cleared")
end, true)

CreateToggle(AimbotTab, "Aimbot", "Enables The Aimbot.", false, function(Bool)
    AimbotEnabled = Bool
    if AimbotEnabled and not TargetLoop then
        TargetLoop = RunService.RenderStepped:Connect(function()
            local ClosestPlayer = GetClosestEnemyPlayer(AimPart)
            if ClosestPlayer then
                local TargetPosition

                if PredictMovements then
                    TargetPosition = PredictMovement(ClosestPlayer)
                else
                    local AimObject = ClosestPlayer.Character:FindFirstChild(AimPart) or ClosestPlayer.Character:FindFirstChild("UpperTorso") -- If not found then should be R15 Torso
                    if AimObject then
                        TargetPosition = AimObject.Position
                    end
                end

                if TargetPosition then
                    LookAt(TargetPosition + Vector3.new(0, Offset, 0))
                end
            end
        end)
    else
        TargetLoop:Disconnect()
        TargetLoop = nil
    end
end, true)

CreateToggle(AimbotTab, "Team Check", "Checks The Teams.", true, function(Bool)
    TeamCheckEnabled = Bool
end, true)

CreateToggle(AimbotTab, "Wall Check", "Checks For Walls.", true, function(Bool)
    WallCheckEnabled = Bool
end, true)

CreateToggle(AimbotTab, "Smoothen", "Smoothens The Camera Movement.", false, function(Bool)
    SmoothenEnabled = Bool
end, true)

CreateToggle(AimbotTab, "Target Closest To Position", "Targets the Nearest Enemy to Position.", false, function(Bool)
    ClosestPosition = Bool
end, true)

CreateToggle(AimbotTab, "Ignore Friends", "Ignores Friends Of Local Player.", false, function(Bool)
    IgnoreFriends = Bool
end, true)

CreateToggle(AimbotTab, "Predict Movements", "Enables Movement Prediction.", false, function(Bool)
    PredictMovements = Bool
end, true)

CreateInput(AimbotTab, "Prediction Distance", "Distance Of Scalar Value.", function(Text)
    PredictDistance = tonumber(Text) or 3
end, true)

CreateInput(AimbotTab, "Player", "Finds The Player To Add/Remove From The List.", function(Text)
    local Player = FindPlayerWithName(Text)
    if Player then
        InputPlayer = Player
    else
        InputPlayer = LocalPlayer
    end
end, true)

CreateButton(AimbotTab, "Add To Allies List", "Adds The Player To The Allies List.", function()
    if InputPlayer then
        local PlayerInfo = GetPlayerName(InputPlayer)
        if not IsPlayerListed(AlliesTable, InputPlayer) then
            table.insert(AlliesTable, InputPlayer)
        end
    end
end, true)

CreateButton(AimbotTab, "Remove From Allies List", "Removes The Player From The Allies List.", function()
    if InputPlayer then
        local PlayerInfo = GetPlayerName(InputPlayer)
        if IsPlayerListed(AlliesTable, InputPlayer) then
            RemoveFromTable(AlliesTable, InputPlayer)
        end
    end
end, true)

CreateSlider(AimbotTab, "Offset", "Sets the Offset to Aimbot.", 100, 0, false, 0.1, function(Value)
    Offset = Value
end, true)

CreateDropdown(AimbotTab, "Aimbot Target:", "Body Part To Target", {"Head", "HumanoidRootPart", "Torso"}, function(Selected)
    AimPart = Selected
end, true)

CreateToggle(ReportTab, "Enabled", "Enables Auto Report.", true, function(Bool)
    AutoReportEnabled = Bool
end, true)

CreateToggle(ReportTab, "Single Report", "Enables Single Report.", false, function(Bool)
    TargetOnePlayer = Bool
end, true)

CreateToggle(ReportTab, "Filter Messages", "Enables Filter Messages.", false, function(Bool)
    Filter = Bool
end, true)

CreateInput(ReportTab, "Target", "Finds The Player To Set As Target.", function(Text)
    local Player = FindPlayerWithName(Text)
    if Player then
        local PlayerName = GetPlayerName(Player)
        TargetPlayer = Player
    else
        TargetPlayer = LocalPlayer
    end
end, true)

CreateDropdown(AnimationsTab, "Selected Animation", "Animations.", {"Crazy Slash", "Open", "R15 Spinner", "Arms Out", "Float Slash", "Weird Zombie", "Down Slash", "Pull", "Circle Arm", "Bend", "Rotate Slash", "Fling Arms"}, UpdateAnimationId, true)

CreateToggle(AnimationsTab, "Playing", "If Animation Is Playing.", false, function(IsPlaying)
    if IsPlaying then
        PlayAnimation()
    else
        if AnimationTrack then
            AnimationTrack:Stop()
        end
        CancelTween()
    end
end, true)

CreateSlider(AnimationsTab, "Playback", "Set playback position.", 1, 0, false, 0.01, function(Value)
    AdjustPlayback(Value)
end, true)

CreateInput(AnimationsTab, "Speed", "Set animation speed.", function(Input)
    SetSpeed(Input)
end, true)

CreateInput(AnimationsTab, "A - B", "Smooth Lerp Between Two Time Positions.", function(Input)
    if Input == "" then
        CancelTween()
    else
        HandleInputForAB(Input)
    end
end, true)

CreateToggle(AnimationsTab, "Hug", "Plays Animation For: Hug", false, function(IsPlaying)
    if IsPlaying then
        local Humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        for _, PlayingTrack in pairs(Humanoid:GetPlayingAnimationTracks()) do
            PlayingTrack:Stop()
        end
        for _, Id in next, PresetAnimations["hug"] do
            Humanoid:LoadAnimation(Instance.new("Animation", {AnimationId = "rbxassetid://"..Id})):Play()
        end
    end
end, true)


local ServerButtons = pcall(function()
    for _, File in ipairs(listfiles(GameFolder)) do
        local FileContent = readfile(GameFolder .. "/" .. File) -- Convert spaces back to underscores for reading file
        local FileTable = HttpService:JSONDecode(FileContent)
        local PlaceId = FileTable.Place
        local JobId = FileTable.Server
        ServersTab.newButton(File:gsub("_", " "):gsub(".json", ""), JobId, function()
            local Notification = string.format("Teleporting To Server: %s", JobId)
            local Success, Error = pcall(function()
                TeleportService:TeleportToPlaceInstance(PlaceId, JobId)
            end)
            Notify({
                Description = Success and Notification or "Error:" .. tostring(Error),
                Title = "Warning!",
                Duration = 5
            }) 
        end)
    end
end)

Players.PlayerChatted:Connect(function(ChatType, Target, Message)
    local LowercaseMessage = Message:lower()
    if Target ~= LocalPlayer then
        if IsActive and ChatType ~= Enum.PlayerChatType.Whisper and (not MifyuOnly or Target.Name:lower() == "mifyu06") and (not PriorFriendsOnly or IsFriendOfLocalPlayer(Target)) and not IsPlayerListed(BlacklistedPlayers, Target) then
            local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local TargetCharacter = Target.Character or Target.CharacterAdded:Wait()
            local LocalPlayerDisplay, LocalPlayerName = LocalPlayer.DisplayName, LocalPlayer.Name
            local LowercaseDisplay, LowercaseName = LocalPlayerDisplay:lower(), LocalPlayerName:lower()
            
            local CheckZane = string.find(LowercaseMessage, "zane")
            local CheckDisplay = string.find(LowercaseMessage, LowercaseDisplay)
            local CheckName = string.find(LowercaseMessage, LowercaseName)
            local CheckBaby = string.find(LowercaseMessage, "baby")
            
            if CheckZane or CheckDisplay or CheckName or (MifyuOnly and CheckBaby) then
                if Character and TargetCharacter then
                    local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
                    local TargetRootPart = TargetCharacter:WaitForChild("HumanoidRootPart")
                    
                    HumanoidRootPart.CFrame = CFrame.new(TargetRootPart.CFrame.LookVector * 2 + TargetRootPart.Position, TargetRootPart.Position)
                end
            end
        end
        
        if AutoReportEnabled then
            if not TargetOnePlayer and (not TargetPlayer or Target ~= TargetPlayer) then
                for Word, ReportString in next, BadWordsList do
                    if string.find(LowercaseMessage, Word) then
                        Report(Target, Message)
                    end
                end
            elseif TargetOnePlayer and TargetPlayer and Target == TargetPlayer then
                if not Filter then
                    Report(Target, Message)
                else
                    for Word, ReportString in next, BadWordsList do
                        if string.find(LowercaseMessage, Word) then
                            Report(Target, Message)
                        end
                    end
                end
            end
        end
    end
end) 

