local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

_G.Afk = false

local Player = Players.LocalPlayer
local Humanoid
local LastMoveTime = tick()
local IsLegacyChat = TextChatService.ChatVersion == "LegacyChatService"
local IsAFK = false

local function SendChatMessage(Message)
    local FormattedMessage = "[Zaney AI]: " .. Message
    if not IsLegacyChat then
        TextChatService.TextChannels.RBXGeneral:SendAsync(FormattedMessage)
    else
        ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(FormattedMessage, "All")
    end
end

local function SetupCharacter(Character)
    Humanoid = Character:WaitForChild("Humanoid")
    Humanoid:GetPropertyChangedSignal("MoveDirection"):Connect(function()
        if Humanoid.MoveDirection.Magnitude > 0 then
            if IsAFK then
                IsAFK = false
                SendChatMessage("Master's back. Welcome back, Zane.")
            end
            LastMoveTime = tick()
        end
    end)
end

Player.CharacterAdded:Connect(function(Character)
    SetupCharacter(Character)
end)

if Player.Character then
    SetupCharacter(Player.Character)
end

Players.PlayerChatted:Connect(function(ChatType, Target, Message)
    if _G.Afk then  
        local LowercaseMessage = Message:lower()
        if Target ~= Player then
            local PlayerDisplay, PlayerName = Player.DisplayName, Player.Name
            local LowercaseDisplay, LowercaseName = PlayerDisplay:lower(), PlayerName:lower()
            
            local CheckDisplay = string.find(LowercaseMessage, LowercaseDisplay)
            local CheckName = string.find(LowercaseMessage, LowercaseName)
            
            if (CheckDisplay ~= nil or CheckName ~= nil) and IsAFK then
                SendChatMessage("Master is currently AFK. You may say “Zane” if you need him and he'll be teleported to you.")
            end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if _G.Afk then  
        local CurrentTime = tick()
        if CurrentTime - LastMoveTime >= 60 and not IsAFK then
            IsAFK = true
            SendChatMessage("Master has now been AFK for 60 seconds.")
        end
    end
end)
