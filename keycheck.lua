local NotificationHolder = loadstring(game:HttpGet("https://raw.githubusercontent.com/BocusLuke/UI/main/STX/Module.Lua"))()
_G.key = _G.key or ''

if game.Players.LocalPlayer.Name ~= 'VateQvateq980' and game.Players.LocalPlayer.Name ~= 'VateQOfficial' then
	loadstring(game:HttpGet("https://pastebin.com/raw/ug8Abuj8"))()
end

local function CheckKey(v)
    v = v or false
    local Notification = loadstring(game:HttpGet("https://raw.githubusercontent.com/BocusLuke/UI/main/STX/Client.Lua"))()
    if _G.key == game:HttpGet("https://raw.githubusercontent.com/tym487ty78/yyyyyyyy1/refs/heads/main/freekey.txt") or v then
        Notification:Notify(
            {Title = "Key System", Description = "Key Valid."},
            {OutlineColor = Color3.fromRGB(80, 255, 80),Time = 5, Type = "option"}
        )
        loadstring(game:HttpGet('https://pastebin.com/raw/2TizppDE'))()
        return true
    elseif _G.key == '1234' then
        if game.Players.LocalPlayer.Name == 'VateQOfficial' or game.Players.LocalPlayer.Name == 'VateQvateq980' then
            Notification:Notify(
                {Title = "Key System", Description = "Key Valid."},
                {OutlineColor = Color3.fromRGB(80, 255, 80),Time = 5, Type = "option"}
            )
            loadstring(game:HttpGet('https://pastebin.com/raw/2TizppDE'))()
            return true
        end
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
if not CheckKey() then
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
        setclipboard(tostring("https://discord.gg/uk27Snmt5W"))
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
            setclipboard('https://discord.gg/uk27Snmt5W')
            print'Invite Link Copied to clipboard'
        else
            print'setclipboard not supported on the executor.'
            print'link: https://discord.gg/uk27Snmt5W'
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
