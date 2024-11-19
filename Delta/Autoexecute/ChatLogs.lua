local Players = game:GetService("Players")
local TCS = game:GetService("TextChatService")
local Success, Error = pcall(function()
    Players.PlayerChatted:Connect(function(ChatType, Player, Message)
        print("[SPY][".. Player.DisplayName .."]: ".. Message)
    end)
end)

if Success then
    print("Woohoo!")
else
    print("Error: ", Error)
end

-- local OldNameCall
-- OldNameCall = hookmetamethod(methods, "__namecall", function(Self, ...)
--     local Args = {...}
--     local NamecallMethod = getnamecallmethod()
-- 
--     if not checkcaller() and NamecallMethod == "SendMessage" or NamecallMethod == "RegisterSayMessageFunction" then
--         print(NamecallMethod, " was fired.")
--     end
-- 
--     return OldNameCall(Self, ...)
-- end)
-- 