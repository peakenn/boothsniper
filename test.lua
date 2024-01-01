local osclock = os.clock()
repeat task.wait() until game:IsLoaded()

setfpscap(30)
game:GetService("RunService"):Set3dRenderingEnabled(false)
local Booths_Broadcast = game:GetService("ReplicatedStorage").Network:WaitForChild("Booths_Broadcast")
local Players = game:GetService('Players')
local getPlayers = Players:GetPlayers()
local PlayerInServer = #getPlayers
local http = game:GetService("HttpService")
local ts = game:GetService("TeleportService")
local rs = game:GetService("ReplicatedStorage")
local playerID, snipeNormal

if not snipeNormalPets then
    snipeNormalPets = false
end

local vu = game:GetService("VirtualUser")
Players.LocalPlayer.Idled:connect(function()
   vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
   task.wait(1)
   vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

for i = 1, PlayerInServer do
   for ii = 1,#alts do
        if getPlayers[i].Name == alts[ii] and alts[ii] ~= Players.LocalPlayer.Name then
            jumpToServer()
        end
    end
end

local function processListingInfo(uid, gems, item, version, shiny, amount, boughtFrom, boughtStatus, mention)
    local gemamount = Players.LocalPlayer.leaderstats["💎 Diamonds"].Value
    local snipeMessage ="||".. Players.LocalPlayer.Name .. "||"
    local weburl, webContent, webcolor
    if version then
        if version == 2 then
            version = "Rainbow "
        elseif version == 1 then
            version = "Golden "
        end
    else
       version = ""
    end

    if boughtStatus then
	webcolor = tonumber(0x00ff00)
	weburl = webhook
        snipeMessage = snipeMessage .. " CALDI!! "
	if mention then 
            webContent = "<@".. userid ..">"
        else
	    webContent = ""
	end
	if snipeNormal == true then
	    weburl = normalwebhook
	end
    else
	webcolor = tonumber(0xff0000)
	weburl = webhookFail
	snipeMessage = snipeMessage .. " CALAMADI!! "
    end
    
    snipeMessage = snipeMessage .. "**" .. version
    
    if shiny then
        snipeMessage = snipeMessage .. " Shiny "
    end
    
    snipeMessage = snipeMessage .. item .. "**"
    
    local message1 = {
        ['content'] = webContent,
        ['embeds'] = {
            {
		["author"] = {
			["name"] = "Erdogan",
			["icon_url"] = "https://media.discordapp.net/attachments/779999980571983882/1191495486943793192/Baslksz.jpg?ex=65a5a5a5&is=659330a5&hm=e3e09e69670cee67edfd45ed0e867d00f26a8f4d657da2523780605c76b3bffa&",
		},
                ['title'] = snipeMessage,
                ["color"] = webcolor,
                ["timestamp"] = DateTime.now():ToIsoDate(),
                ['fields'] = {
                    {
                        ['name'] = "__Price:__",
                        ['value'] = tostring(gems) .. " 💎",
                    },
                    {
                        ['name'] = "__Bought from:__",
                        ['value'] = "||"..tostring(boughtFrom).."|| ",
                    },
                    {
                        ['name'] = "__Amount:__",
                        ['value'] = tostring(amount) .. "x",
                    },
                    {
                        ['name'] = "__Remaining gems:__",
                        ['value'] = tostring(gemamount) .. " 💎",
                    },      
                    {
                        ['name'] = "__PetID:__",
                        ['value'] = "||"..tostring(uid).."||",
                    },
                },
		["footer"] = {
                        ["icon_url"] = "https://media.discordapp.net/attachments/779999980571983882/1191495486943793192/Baslksz.jpg?ex=65a5a5a5&is=659330a5&hm=e3e09e69670cee67edfd45ed0e867d00f26a8f4d657da2523780605c76b3bffa&", -- optional
                        ["text"] = "VERGI!"
		}
            },
        }
    }

    local jsonMessage = http:JSONEncode(message1)
    local success, webMessage = pcall(function()
	http:PostAsync(weburl, jsonMessage)
    end)
    if success == false then
        local response = request({
            Url = weburl,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = jsonMessage
        })
    end
end

local function checklisting(uid, gems, item, version, shiny, amount, username, playerid)
    local Library = require(rs:WaitForChild('Library'))
    local purchase = rs.Network.Booths_RequestPurchase
    gems = tonumber(gems)
    local ping = false
    snipeNormal = false
    local type = {}
    pcall(function()
        type = Library.Directory.Pets[item]
    end)

    if amount == nil then
        amount = 1
    end

    local price = gems / amount

    if type.exclusiveLevel and price <= 60000 and item ~= "Banana" and item ~= "Coin" then
        local boughtPet, boughtMessage = purchase:InvokeServer(playerid, uid)
        processListingInfo(uid, gems, item, version, shiny, amount, username, boughtPet, ping)
    elseif item == "Titanic Christmas Present" and price <= 200000 then
        local boughtPet, boughtMessage = purchase:InvokeServer(playerid, uid)
    processListingInfo(uid, gems, item, version, shiny, amount, username, boughtPet, ping)
    elseif string.find(item, "Exclusive") and price <= 60000 then
        local boughtPet, boughtMessage = purchase:InvokeServer(playerid, uid)
    processListingInfo(uid, gems, item, version, shiny, amount, username, boughtPet, ping)
    elseif item == "Crystal Key" and gems <= 25000 then
        game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)
        processListingInfo(uid, gems, item, version, shiny, amount, username)
    elseif item == "Crystal Key Lower Half" and gems <= 4000 then
        game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)
      processListingInfo(uid, gems, item, version, shiny, amount, username)
    elseif item == "Crystal Key Upper Half" and gems <= 10000 then
        game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)
      processListingInfo(uid, gems, item, version, shiny, amount, username)
    elseif item == "Spinny Wheel Ticket" and gems <= 8000 then
        game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)
      processListingInfo(uid, gems, item, version, shiny, amount, username)
    elseif item == "Fortune" and gems <= 300000 then
        game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)
      processListingInfo(uid, gems, item, version, shiny, amount, username)
    elseif item == "Booth Slot Voucher" and gems <= 30000 then
        game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)
      processListingInfo(uid, gems, item, version, shiny, amount, username)
    elseif item == "Lucky Block" and gems <= 800000 then
        game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)
      processListingInfo(uid, gems, item, version, shiny, amount, username)		
    elseif class == "Charm" and gems <= 4000 then
        game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)
      processListingInfo(uid, gems, item, version, shiny, amount, username)
    elseif item == "Charm Stone" and gems <= 40000 then
        game:GetService("ReplicatedStorage").Network.Booths_RequestPurchase:InvokeServer(playerid, uid)
      processListingInfo(uid, gems, item, version, shiny, amount, username)
    elseif type.huge and price <= 3000000 then
        local boughtPet, boughtMessage = purchase:InvokeServer(playerid, uid)
        if boughtPet == true then
            ping = true
    end
        processListingInfo(uid, gems, item, version, shiny, amount, username, boughtPet, ping)  
    elseif type.titanic and price <= 10000000 then
        local boughtPet, boughtMessage = purchase:InvokeServer(playerid, uid)
        if boughtPet == true then
        ping = true
    end
        processListingInfo(uid, gems, item, version, shiny, amount, username, boughtPet, ping)
    elseif gems == 1 and snipeNormalPets == true then
    local boughtPet, boughtMessage = purchase:InvokeServer(playerid, uid)
        processListingInfo(uid, gems, item, version, shiny, amount, username, boughtPet, ping)  
    end
end
Booths_Broadcast.OnClientEvent:Connect(function(username, message)
    local playerIDSuccess, playerError = pcall(function()
	playerID = message['PlayerID']
    end)
    if playerIDSuccess then
        if type(message) == "table" then
            local listing = message["Listings"]
            for key, value in pairs(listing) do
                if type(value) == "table" then
                    local uid = key
                    local gems = value["DiamondCost"]
                    local itemdata = value["ItemData"]

                    if itemdata then
                        local data = itemdata["data"]

                        if data then
                            local item = data["id"]
                            local version = data["pt"]
                            local shiny = data["sh"]
                            local amount = data["_am"]
                            checklisting(uid, gems, item, version, shiny, amount, username, playerID)
                        end
                    end
                end
            end
	end
    end
end)

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local function request(url)
    return game:HttpGet(url)
end

local function pingServer(serverId)
    local pingUrl = "https://games.roblox.com/v1/games/%s/servers/%s"
    local req = request(string.format(pingUrl, 15502339080, serverId))
    local body = HttpService:JSONDecode(req)
    
    if body and body.ping then
        return body.ping
    else
        return math.huge -- Return a large value if ping information is not available
    end
end

local function jumpToServer()
    local sfUrl = "https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=%s&limit=%s&excludeFullGames=true"
    
    local function fetchServers(url)
        local req = request(url)
        local body = HttpService:JSONDecode(req)
        
        local servers = {}
        
        if body and body.data then
            for _, v in ipairs(body.data) do
                if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.id ~= game.JobId then
                    table.insert(servers, v.id)
                end
            end
        end
        
        return servers, body.nextPageCursor
    end
    
    local function iterateServers(url, deep)
        local servers = {}
        for i = 1, deep, 1 do
            local fetchedServers, nextPageCursor = fetchServers(url)
            for _, serverId in ipairs(fetchedServers) do
                table.insert(servers, serverId)
            end
            url = string.format(sfUrl .. "&cursor=" .. nextPageCursor, 15502339080, "Desc", 100)
            task.wait(0.1)
        end
        return servers
    end
    
    local deep = math.random(1, 3)
    local url = string.format(sfUrl, 15502339080, "Desc", 100)
    
    local servers = iterateServers(url, deep)
    
    local minPing = math.huge
    local selectedServer = nil
    
    for _, serverId in ipairs(servers) do
        local serverPing = pingServer(serverId)
        if serverPing < minPing then
            minPing = serverPing
            selectedServer = serverId
        end
    end
    
    if selectedServer then
        TeleportService:TeleportToPlaceInstance(15502339080, selectedServer, game:GetService("Players").LocalPlayer)
    else
        print("No suitable servers found.")
    end
end

local function onPlayerRemoving(player)
    local playerCount = #game:GetService("Players"):GetPlayers()
    if playerCount < 22 then
        jumpToServer()
    end
end

Players.PlayerAdded:Connect(function(player)
    for i = 1,#alts do
        if player.Name == alts[i] and alts[i] ~= Players.LocalPlayer.Name then
            jumpToServer()
        end
    end
end) 

Players.PlayerRemoving:Connect(onPlayerRemoving)
Players.PlayerAdded:Connect(onPlayerAdded)

while true do
    if math.floor(os.clock() - osclock) >= math.random(900, 1200) then
        jumpToServer()
    end
    task.wait(1)
end
