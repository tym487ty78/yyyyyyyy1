local function firebase()
    local does = false
    local response = request({
        Url = "https://chubkeys-16fe8-default-rtdb.firebaseio.com/.json",
        Method = "GET",
        Headers = {
            ["Content-Type"] = "application/json"}
        }
    )
    if response.StatusCode == 200 then
        if game:GetService('HttpService'):JSONDecode(response.Body)['keys'] then
            does = true
        end
    end
    return does
end

local function cfirebase()
    request({
        Url = "https://chubkeys-16fe8-default-rtdb.firebaseio.com/.json",
        Method = "PUT",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = game:GetService("HttpService"):JSONEncode({keys={''}})
    })
end

local function KeyExists(v)
    local isin = false
    local enddate = ''
    local daysleft = ''
    local keys = game:GetService("HttpService"):JSONDecode(game:GetService("HttpService"):HttpGet("https://raw.githubusercontent.com/tym487ty78/yyyyyyyy1/refs/heads/main/keys.json"))
    for key, e in keys do
        if v == key then
            isin = true
            enddate = e
        end
    end

    return {isin, enddate}
end

local function KeyApplied(key)
    local isin = false
    local keydata = {}

    if not firebase() then
        cfirebase()
    end

    local response = request({
        Url = "https://chubkeys-16fe8-default-rtdb.firebaseio.com/keys.json",
        Method = "GET",
        Headers = {
            ["Content-Type"] = "application/json"}
        }
    )

    local success, data = pcall(function()
        return game:GetService("HttpService"):JSONDecode(response.Body)
    end)

    if response.StatusCode == 200 then
        if success then
            for keyname, sdata in pairs(data) do
                if key == keyname then
                    isin = true
                    keydata=sdata
                end
            end
        end
    end
    return {isin, keydata}
end

local function ApplyKey(v)
    local function IsApplied(f)
        local isin = false

        if not firebase() then
            cfirebase()
        end

        local response = request({
            Url = "https://chubkeys-16fe8-default-rtdb.firebaseio.com/keys.json",
            Method = "GET",
            Headers = {
                ["Content-Type"] = "application/json"}
            }
        )

        local success, data = pcall(function()
            return game:GetService("HttpService"):JSONDecode(response.Body)
        end)
    
        if response.StatusCode == 200 then
            if success then
                for keyname, sdata in game:GetService("HttpService"):JSONDecode(response.Body) do
                    if f == keyname then
                        isin = true
                    end
                end
            end
        end
        return isin
    end

    local function GetCharacterName()
        if game.Players.LocalPlayer.Character then
            return game.Players.LocalPlayer.Character.Name
        end
    end

    local function ExistanteKey(kye)
        local abalastic = false
        for kd, ed in game:GetService("HttpService"):JSONDecode(game:HttpGet('https://raw.githubusercontent.com/tym487ty78/yyyyyyyy1/refs/heads/main/keys.json')) do
            if kd == kye then
                abalastic= true
                break
            end
        end
        return abalastic
    end

    if not IsApplied(v) and ExistanteKey(v) then
        local key = v
        local newData = {
            hwid = game:GetService("RbxAnalyticsService"):GetClientId() or '0',
            ip = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://api.ipify.org/?format=json")).ip or '0',
            enddate = game:GetService("HttpService"):JSONDecode(game:HttpGet('https://raw.githubusercontent.com/tym487ty78/yyyyyyyy1/refs/heads/main/keys.json'))[key],
            userdata = {
                username = game.Players.LocalPlayer.Name or '.NotFound',
                userid = tostring(game.Players.LocalPlayer.UserId) or '.NotFound',
                displayname = game.Players.LocalPlayer.DisplayName or '.NotFound',
                charactername = GetCharacterName() or '.NotFound'
            }
        }

        local requestData = {
            Url = ("https://chubkeys-16fe8-default-rtdb.firebaseio.com/keys/" .. key .. ".json"),
            Method = "PUT",
            Headers = {["Content-Type"] = "application/json"},
            Body = game:GetService("HttpService"):JSONEncode(newData)
        }
        
        request(requestData)
    end
end

local function IsKeyActive(key)
    local currentdate = os.date("%d.%m.%Y")
    local active = 'key doesnt exists.'
    local keys = game:GetService("HttpService"):JSONDecode(game:GetService("HttpService"):HttpGet("https://raw.githubusercontent.com/tym487ty78/yyyyyyyy1/refs/heads/main/keys.json"))
    local enddate = keys[key]
    local enddays = ''
    local works = false

    local function calculatedates(dateStr1, dateStr2)
        local function parseDate(dateStr)
            local day, month, year = dateStr:match("(%d+).(%d+).(%d+)")
            if day and month and year then
                return tonumber(year), tonumber(month), tonumber(day)
            else
                return nil, nil, nil
            end
        end
        local year1, month1, day1 = parseDate(dateStr1)
        local year2, month2, day2 = parseDate(dateStr2)
        if not (year1 and month1 and day1) or not (year2 and month2 and day2) then
            return "error"
        end
        local date1 = os.time{year = year1, month = month1, day = day1}
        local date2 = os.time{year = year2, month = month2, day = day2}
        local differenceInSeconds = date2 - date1
        local differenceInDays = differenceInSeconds / (60 * 60 * 24)
      
        return tostring(differenceInDays)
    end

    if keys[key] ~= nil then
        if tonumber(calculatedates(currentdate,keys[key])) >= 1 then
            active = 'key ends in: '..calculatedates(currentdate,keys[key]) .. 'd'
            enddays = calculatedates(currentdate,keys[key])
            works = true
        else
            active = 'key is outdated'
            works = false
        end
    else
        active = 'key doesnt exists.'
        works = false
    end

    return {active, enddays, currentdate, enddate, works}
end

---
--- - DOCUMENTATION -
---

--[[

local v = 'CANDYHUBxENDED'

KeyApplied(v) -- checks if v string value is in databse
-- returns list: {IsInDatabase=true/false, KeyData={hwid="stringvalue",ip="stringValue"}}

ApplyKey(v) -- checks if key exists if not then applies the key of the current client hwid

print(KeyApplied(v)[1]) -- prints true/false (if key is in database)

print(KeyApplied(v)[2].hwid)
print(KeyApplied(v)[2].ip)
print(KeyApplied(v)[2].enddate)

print(KeyApplied(v)[2].userdata.username)
print(KeyApplied(v)[2].userdata.userid)
print(KeyApplied(v)[2].userdata.displayname)
print(KeyApplied(v)[2].userdata.charactername)

KeyExists(v) -- checks if v string value (key) is in the json list (github keys.json)
-- returns list: {IsInJsonList = true/false, Enddate = "01.01.2025"}

print(KeyExists(v)[1]) -- prints true/false 
print(KeyExists(v)[2]) -- prints date string

IsKeyActive(key) -- checks if key is outdated

print(IsKeyActive(v)[1]) -- active={'key ends in: 7d','key is outdated', 'key doesnt exists}
print(IsKeyActive(v)[2]) -- enddays = 7 (string)
print(IsKeyActive(v)[3]) -- currentdate = 24.12.2024
print(IsKeyActive(v)[4]) -- enddate = 31.12.2024
print(IsKeyActive(v)[5]) -- works = true/false
]]

 -- PremiumCheck(_G.key, label, '   pre', 3)

local function PremiumCheck(key)
	key = key or nil
    v = false
    b = false
	if KeyExists(key)[1] then
		if IsKeyActive(key)[5] then
			if not KeyApplied(key)[1] then
				ApplyKey(key)
                v= true
                b= true
                if game.CoreGui:FindFirstChild('hexagon-docs') then
                    game.CoreGui:FindFirstChild('hexagon-docs'):Destroy()
                end
			else
				if KeyApplied(key)[2].hwid == game:GetService("RbxAnalyticsService"):GetClientId() then
                    v= true
                    if game.CoreGui:FindFirstChild('hexagon-docs') then
                        game.CoreGui:FindFirstChild('hexagon-docs'):Destroy()
                    end
				end
			end
		end
	end
    return {v,b}
end

local function FreemiumCheck(key)
	local ava = false
	local u = game.Players.LocalPlayer.Name

	if key == game:HttpGet("https://raw.githubusercontent.com/tym487ty78/yyyyyyyy1/refs/heads/main/freekey.txt") then
		ava = true
        if game.CoreGui:FindFirstChild('hexagon-docs') then
            game.CoreGui:FindFirstChild('hexagon-docs'):Destroy()
        end
	end
	return ava
end

local function GamepassCheck()
	if game:GetService("MarketplaceService"):UserOwnsGamePassAsync(game.Players.LocalPlayer.UserId, 987985380) then
        if game.CoreGui:FindFirstChild('hexagon-docs') then
            game.CoreGui:FindFirstChild('hexagon-docs'):Destroy()
        end
        return true
    elseif string.find(string.lower(game.Players.LocalPlayer.Name), 'vateq') then
        if game.CoreGui:FindFirstChild('hexagon-docs') then
            game.CoreGui:FindFirstChild('hexagon-docs'):Destroy()
        end
        return true
	else
		return false
	end
end

local function BuyGamepass(v)
	v=v or nil
	if v == 2 then
		if not game:GetService("MarketplaceService"):UserOwnsGamePassAsync(game.Players.LocalPlayer.UserId, 987985380) then
			game:GetService("MarketplaceService"):PromptGamePassPurchase(game.Players.LocalPlayer, 987985380)
		end
	else
		game:GetService("MarketplaceService"):PromptGamePassPurchase(game.Players.LocalPlayer, 987985380)
	end
end





if not getgenv()._gamepass then
	getgenv()._gamepass = false
end

if not getgenv()._premiumkey then
	getgenv()._premiumkey = ''
end

if not getgenv()._key then
	getgenv()._key = ''
end


if getgenv()._gamepass and GamepassCheck() then
    loadstring(game:HttpGet('https://raw.githubusercontent.com/tym487ty78/yyyyyyyy1/refs/heads/main/NextStep.lua'))()
elseif PremiumCheck(getgenv()._premiumkey)[1] then
    if PremiumCheck(getgenv()._premiumkey)[2] then
        ApplyKey(getgenv()._premiumkey)
    end
    loadstring(game:HttpGet('https://raw.githubusercontent.com/tym487ty78/yyyyyyyy1/refs/heads/main/NextStep.lua'))()
elseif FreemiumCheck(getgenv()._key) then
    loadstring(game:HttpGet('https://raw.githubusercontent.com/tym487ty78/yyyyyyyy1/refs/heads/main/NextStep.lua'))()
else
    if game.CoreGui:FindFirstChild('hexagon-docs') then
        game.CoreGui:FindFirstChild('hexagon-docs'):Destroy()
    end
    local library = loadstring(game:HttpGet('https://raw.githubusercontent.com/vateq/UILIBrewrites/refs/heads/main/hexagonuilib'))()
    library.settings = {
        guiname = "hexagon-docs",
        title = 'Key System 2.0',
        modal = true,
        font = Enum.Font.SourceSans,
        textsize = 16,
        logo = "rbxassetid://4350178803",
        footer = 'perm key: $3.99 | source: $20',
        textstroke = true,
    }

    local Window = library:CreateWindow(
        Vector2.new(300, 350), -- ui lib size
        Vector2.new((workspace.CurrentCamera.ViewportSize.X / 2) - 250, (workspace.CurrentCamera.ViewportSize.Y / 2) - 250)
    )

    local maintab = Window:CreateTab('Freemium')

    local category = maintab:AddCategory("Freemium Key",1,2)
    category:AddTextBox("Key", "", "", function(v)
        getgenv()._key = v
    end, true)

    category:AddButton('Check Key', function()
        if FreemiumCheck(getgenv()._key) then
            loadstring(game:HttpGet('https://raw.githubusercontent.com/tym487ty78/yyyyyyyy1/refs/heads/main/NextStep.lua'))()
        end
    end)

    local premiumtab = Window:CreateTab('Premium')    
    local category = premiumtab:AddCategory("Premium Key",1,2)

    category:AddTextBox("Key", "", "", function(v)
        getgenv()._premiumkey = v
    end, true)

    category:AddButton('Check Key', function()
        if PremiumCheck(getgenv()._premiumkey)[1] then
            if PremiumCheck(getgenv()._premiumkey)[2] then
                ApplyKey(getgenv()._premiumkey)
            end
            loadstring(game:HttpGet('https://raw.githubusercontent.com/tym487ty78/yyyyyyyy1/refs/heads/main/NextStep.lua'))()
        end
    end)

    local premiumtab = Window:CreateTab('Gamepass')    
    local category = premiumtab:AddCategory("Gamepass",1,2)

    category:AddButton('Gamepass Check', function()
        if GamepassCheck() then
            loadstring(game:HttpGet('https://raw.githubusercontent.com/tym487ty78/yyyyyyyy1/refs/heads/main/NextStep.lua'))()
        end
    end)

    category:AddButton('Buy Gamepass', function()
        BuyGamepass(2 or nil)
    end)
end
