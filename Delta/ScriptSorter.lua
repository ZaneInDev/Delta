local SideBar = game:GetService("CoreGui"):FindFirstChild("FluxusAndroidUI"):FindFirstChild("TabItem"):FindFirstChild("Container"):FindFirstChild("ScriptFrameContainer"):FindFirstChild("ScriptFolder")

if SideBar then
    local UIListLayout = SideBar:FindFirstChildOfClass("UIListLayout")
    
    if UIListLayout then
        local FramesWithNames = {}
        
        for _, Frame in ipairs(SideBar:GetChildren()) do
            if Frame:IsA("Frame") and Frame:FindFirstChildOfClass("TextButton") then
                local TextButton = Frame:FindFirstChildOfClass("TextButton")
                
                if TextButton and TextButton.Text then
                    local FirstWord = TextButton.Text:match("^(%S+)")
                    FramesWithNames[Frame] = FirstWord
                end
            end
        end
        
        for Frame, NewName in pairs(FramesWithNames) do
            if Frame:IsA("Frame") and Frame:FindFirstChildWhichIsA("TextButton") then
                Frame.Name = NewName
            end
        end
        
        UIListLayout.SortOrder = Enum.SortOrder.Name
    else
        warn("No UIListLayout found in ScriptFolder.")
    end
else
    warn("ScriptFolder not found.")
end