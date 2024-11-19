local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")

local FolderName = "Servers"

local TimeInUnix = os.time()
local JobId = game.JobId
local PlaceId = game.PlaceId
local GameName = MarketplaceService:GetProductInfo(PlaceId).Name

local Date = os.date("%H:%M:%S", TimeInUnix)
local Time = os.date("%A, %B %d", TimeInUnix)

local GameFolder = string.format("%s/%s", FolderName, GameName:gsub(" ", ""))
local FilePath = string.format("%s/%s | %s.json", GameFolder, Date, Time)

if not isfolder(FolderName) then
    makefolder(FolderName)
end

if not isfolder(GameFolder) then
    makefolder(GameFolder)
end 

local Info = {
    Game = GameName,
    Place = PlaceId,
    Server = JobId
}

local Success, Result = pcall(function()
    writefile(FilePath, HttpService:JSONEncode(Info))
end)

if Success then
    print("File successfully written.")
else
    warn("Error occurred while writing the file:", Result)
end
