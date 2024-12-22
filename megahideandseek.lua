if game.PlaceId == 5708035517 or game.PlaceId == 6063653725 then

    local SolarisLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/vateq/UILIBrewrites/refs/heads/main/justtestin"))()

    local win = SolarisLib:New({
    Name = "Mega Hide & Seek - by vateq#0",
    FolderToSave = "CandyHub-solarisui"
    })

    _G.gamemode = 'Seek'
    _G.impotoggle = true

    local function PlayerStatus(player)
        if player.Character then
            if player.Character:FindFirstChild("Head") then
                if player.Character.Head:FindFirstChild("SeekerTitle") then
                    if player.Character.Head:FindFirstChild("SeekerTitle"):FindFirstChild("ZOMBIE") then
                        _G.gamemode = 'Infection'
                    end
                    return 'seeker'
                else
                    return 'hidder'
                end
            end
        end
    end

    local function TouchPart(totouch, touchwith, cd)
        local c = touchwith.CFrame
        touchwith.CFrame = totouch.CFrame
        task.wait(cd/1000)
        touchwith.CFrame = c
    end

    local function GetSeekerBeforeRound()
        local statues = game:GetService("Players").LocalPlayer.PlayerGui.Intermission.MainFrame.Status
        if string.find(statues.Text, ' has been chosen!') then
            for i, player in game.Players:GetChildren() do
                if string.find(statues.Text, player.Name) then
                    --return string.gsub(statues.Text, " has been chosen!", '')
                    return player
                else
                    return 'Loading. . .'
                end
            end
        else
            return 'Loading. . .'
        end
    end

    _G.hds = {
        bringcoins = false,
        confuse = false,
        seek = false,
        collectmode = 'TeleportInterest',
        hide = false,
        getseeked = false,
    }

    local tab = win:Tab("Main")
    local sec = tab:Section("Auto")
    _G.impotoggle = true
    local infolabels = tab:Section("Information")
    local map = infolabels:Label("Map: Loading. . .")
    local farmmode = infolabels:Label("Farm-Mode: Loading. . .")
    local coinsamount= infolabels:Label("Coins: Loading. . .")
    local gemsamount = infolabels:Label("Gems: Loading. . .")

    local function BBBR(v)
        while v and task.wait(1) do
            if workspace.MapHolder:FindFirstChildOfClass("Folder") then
                map:Set('Map: '..workspace.MapHolder:FindFirstChildOfClass("Folder").Name)
            else
                map:Set('Map: Loading. . .')
            end
            if GetSeekerBeforeRound() == game.Players.LocalPlayer or PlayerStatus(game.Players.LocalPlayer) == 'seeker' then
                farmmode:Set('Farm-Mode: Seeker')
            else
                farmmode:Set('Farm-Mode: Hidder')
            end
            --whoisseeker:Set('Seeker: '..GetSeekerBeforeRound())
            -- 'plr.Name has been chosen!'
            coinsamount:Set('Coins: '..tostring(game.Players.LocalPlayer:FindFirstChild('Coins').Value))
            gemsamount:Set('Gems: '..tostring(game.Players.LocalPlayer:FindFirstChild('Diamonds').Value))
        end
    end

    sec:Toggle("Auto Collect Coins", _G.hds.bringcoins,"Toggle", function(v)
        _G.hds.bringcoins = v
        while _G.hds.bringcoins and task.wait() do
            for i, coin in workspace.MapHolder:GetChildren() do
                if coin.Name == 'Coin' and game.Players.LocalPlayer.Character then
                    if game.Players.LocalPlayer.Character:FindFirstChild('HumanoidRootPart') then
                        if _G.hds.collectmode == 'TouchInterest' then
                            firetouchinterest(coin, game.Players.LocalPlayer.Character.HumanoidRootPart, 0)
                            firetouchinterest(coin, game.Players.LocalPlayer.Character.HumanoidRootPart, 1)
                        elseif _G.hds.collectmode == 'TeleportInterest' then
                            TouchPart(coin, game.Players.LocalPlayer.Character.HumanoidRootPart, 5)
                        end
                    end
                end
            end
        end
    end)

    sec:Toggle("Auto Seek", _G.hds.seek,"Toggle", function(v)
        _G.hds.seek = v
        while _G.hds.seek and task.wait() do
            for i, player in game.Players:GetChildren() do
                if player.Character then
                    if player.Character:FindFirstChild('HumanoidRootPart') then
                        if PlayerStatus(game.Players.LocalPlayer) == 'seeker' then
                            if game.Players.LocalPlayer.Character then
                                if PlayerStatus(player) ~= 'seeker' then
                                    TouchPart(player.Character.HumanoidRootPart, game.Players.LocalPlayer.Character.HumanoidRootPart, 5)
                                end
                            end 
                        end
                    end
                end
            end
        end
    end)

    sec:Toggle("Auto Hide", _G.hds.hide,"Toggle", function(v)
        _G.hds.hide = v
        while _G.hds.hide and task.wait(1) do
            if PlayerStatus(game.Players.LocalPlayer) ~= 'seeker' and game.Players.LocalPlayer.Character then
                if not workspace:FindFirstChild('CandyHub-Baseplate_hide') then
                    local baseplate = Instance.new("Part", workspace)
                    baseplate.Name = 'CandyHub-Baseplate_hide'
                    baseplate.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0,1600,0)
                    baseplate.Anchored = true
                    baseplate.Size = Vector3.new(100,2,100)
                end
                if workspace:FindFirstChild('CandyHub-Baseplate_hide') then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace:FindFirstChild('CandyHub-Baseplate_hide').CFrame + Vector3.new(0,10,0)
                end
            end
        end
        if not _G.hds.hide and not v then

        end
    end)

    sec:Toggle("Auto Get Seeked (WARNING USE IT AS A BOT!)", _G.hds.seek,"Toggle", function(v)
        _G.hds.seek = v
        while _G.hds.seek and task.wait() do
            for i, player in game.Players:GetChildren() do
                if player.Character then
                    if player.Character:FindFirstChild('HumanoidRootPart') then
                        if PlayerStatus(game.Players.LocalPlayer) == 'hidder' then
                            if game.Players.LocalPlayer.Character then
                                if PlayerStatus(player) == 'seeker' then
                                    TouchPart(player.Character.HumanoidRootPart, game.Players.LocalPlayer.Character.HumanoidRootPart, 5)
                                end
                            end 
                        end
                    end
                end
            end
        end
    end)

    local tab2 = win:Tab("Settings")
    local labels = tab2:Section("Settings")

    local dropdown = labels:Dropdown("Auto Collect Coins Mode: ", {"TouchInterest", "TeleportInterest"},"TeleportInterest","Dropdown", function(v)
        _G.hds.collectmode = v
    end)

    labels:Toggle("Anti AFK", true,"Toggle", function(v)
        local vu = game:GetService("VirtualUser")
        game:GetService("Players").LocalPlayer.Idled:connect(function()
            vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
            wait(1)
            vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        end)
    end)


    -- freezed:
    -- FreezeTagFrozenIce
    -- classname: Accessory

    BBBR(true)

end
