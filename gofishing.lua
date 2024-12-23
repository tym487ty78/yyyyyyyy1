local function SafeZone(pos)
    if workspace:FindFirstChild('candyhub-safezone') then
        workspace:FindFirstChild('candyhub-safezone').Anchored = false
        workspace:FindFirstChild('candyhub-safezone').CFrame = pos
        workspace:FindFirstChild('candyhub-safezone').Anchored = true
        workspace:FindFirstChild('candyhub-safezone').Rotation = Vector3.new(0,0,0)
    else
        local part = Instance.new('Part', workspace)
        part.Name = 'candyhub-safezone'
        part.CFrame = pos
        part.Size = Vector3.new(10,2,10)
        part.Transparency=0.8
        part.Anchored = true
        part.Rotation = Vector3.new(0,0,0)
    end
end

local function AntiGamepass(mode)
    mode = mode or 'make'
    if mode == 'make' then
        if not game.Players.LocalPlayer.PlayerGui:FindFirstChild('abg2224') then
            local screengui = Instance.new('ScreenGui',game.Players.LocalPlayer.PlayerGui)
            screengui.Name = 'abg2224'
            local ib = Instance.new('ImageButton',screengui)
            ib.Name = 'AntiBuyGamepass'
            ib.Position = UDim2.new(0.001,0,0.001,0)
            ib.Size = UDim2.new(0.05,0,0.001,0)
            ib.BackgroundColor3 = Color3.fromRGB(1,1,1)
        end
    elseif mode == 'check_true' then
        if game.Players.LocalPlayer.PlayerGui:FindFirstChild('abg2224') then
            game.Players.LocalPlayer.PlayerGui:FindFirstChild('abg2224').Enabled = true
        end 
    elseif mode == 'check_false' then
        if game.Players.LocalPlayer.PlayerGui:FindFirstChild('abg2224') then
            game.Players.LocalPlayer.PlayerGui:FindFirstChild('abg2224').Enabled = false
        end 
    end
end


if game.CoreGui:FindFirstChild('chub-ui{13}') then
	game.CoreGui:FindFirstChild('chub-ui{13}'):Destroy()
end
local library = loadstring(game:HttpGet('https://raw.githubusercontent.com/vateq/UILIBrewrites/refs/heads/main/hexagonuilib'))()
library.settings = {
	guiname = "chub-ui{13}",
	title = 'Candy Hub - Go Fishing',
	modal = true,
	font = Enum.Font.SourceSans,
	textsize = 16,
	logo = "rbxassetid://4350178803",
	footer = '- made by vateq.',
	textstroke = true,
}

_G.candyhub = {
    autocast = false,
    autocatch = false,
    autotarget = false,
    autosell = false,
    autostat = false,
    castmode = 'bypass',
    stats={
        fishingspeed = false,
        strength = false,
        luck = false
    },
    rod = 'Steel Rod',
    bait = 'Apple',
    potion = 'Luck Potion I',
    holdtime = 3,
    freezechar = false,
    autozone = false,
    zone = 'Default Isle',
    sellamount = 50,
    infbait = false,
    sellallwait=2.2,
}

local zones = {
    defaultisle = CFrame.new(942.536377, 127.545708, 254.444763, 0.682717562, -0.203110099, 0.701885343, 1.42572915e-07, 0.960588872, 0.277973056, -0.730682373, -0.189776987, 0.655810952),
    vulcanoisle = CFrame.new(829.335938, 128.694641, 926.749512, -0.606504142, -0.202531084, 0.768852293, -1.31778265e-07, 0.967012167, 0.254730254, -0.795080304, 0.154494852, -0.58649689),
    snowybiome = CFrame.new(2192.81934, 132.483459, 262.021057, -0.948030829, -0.0503469296, 0.314169943, -1.65972523e-07, 0.987401605, 0.158234358, -0.318178505, 0.150011003, -0.936087132),
    deepwaters = CFrame.new(-22.3140888, 129.08902, -1377.86743, -0.915984094, -0.121885143, 0.382252723, 1.22360916e-07, 0.952738822, 0.303790689, -0.40121457, 0.278267473, -0.872693598),
    ancientocean = CFrame.new(797.303894, 125.975601, -2088.22656, -0.988837481, 0.0538982712, -0.138908133, 1.20399534e-07, 0.932280302, 0.361736745, 0.148998305, 0.357698828, -0.921873689),
    highfield = CFrame.new(2061.84692, 127.464203, -2582.05103, -0.853039742, 9.32625088e-09, -0.521845937, -1.0396163e-08, 1, 3.48658276e-08, 0.521845937, 3.51671332e-08, -0.853039742),
    toxiczone = CFrame.new(3417.6167, 126.026093, -1539.51465, 0.881312668, -0.0369323492, 0.471088022, -2.10134374e-07, 0.99694097, 0.07815855, -0.472533524, -0.0688822195, 0.878616691),
    mansionisland = CFrame.new(4058.69507, 125.416229, 428.03006, -0.27912733, -5.05664755e-09, -0.960254073, -1.83806048e-09, 1, -4.73165862e-09, 0.960254073, 4.4426976e-10, -0.27912733),
    christmasvilage = CFrame.new()
}

local spawns = {
    defaultisle = CFrame.new(792.481934, 131.844788, -229.427643, -0.864148915, -0.129839927, 0.48619771, 2.46146698e-07, 0.966142178, 0.258010328, -0.503236175, 0.222959474, -0.834890664),
    vulcanoisle = CFrame.new(214.123398, 131.182297, 914.233154, 0.963826895, -0.0171396192, -0.265977234, -1.84809636e-07, 0.99793011, -0.0643074587, 0.266528904, 0.0619813092, 0.961831927),
    snowybiome = CFrame.new(2328.47339, 135.450272, 345.681366, 0.0490640029, -0.258781493, 0.964689016, -2.381624e-07, 0.965852261, 0.259093553, -0.998795629, -0.0127123957, 0.0473885164),
    deepwaters = CFrame.new(-994.533936, 130.379425, -1565.90393, -0.0783816352, 0.160100803, -0.983983755, 1.61409389e-07, 0.987020433, 0.160594881, 0.996923447, 0.0125875305, -0.0773643032),
    ancientocean = CFrame.new(597.376038, 143.6138, -2927.52539, -0.991514087, -0.0304244701, 0.126389101, 2.31731704e-07, 0.972227693, 0.234037116, -0.129999444, 0.232051119, -0.963977396),
    highfield = CFrame.new(2580.38281, 130.265442, -3445.95239, -0.993647218, -0.0136877885, 0.111704528, 1.65538822e-07, 0.992575824, 0.121627413, -0.112540022, 0.120854758, -0.986270189),
    toxiczone = CFrame.new(4688.34961, 140.951889, -2436.05688, -0.662642479, -0.202632681, 0.721002758, 1.70248995e-07, 0.96270287, 0.27056092, -0.748935878, 0.179285273, -0.637927771),
    mansionisland = CFrame.new(5128.0752, 159.531723, 701.879883, -0.00247889198, -5.67627758e-08, 0.999996901, -5.53703998e-08, 1, 5.66256908e-08, -0.999996901, -5.52298616e-08, -0.00247889198),
    christmasvilage = CFrame.new()
}


local Window = library:CreateWindow(
	Vector2.new(350, 375), 
	Vector2.new(
		(workspace.CurrentCamera.ViewportSize.X / 2) - 250, 
		(workspace.CurrentCamera.ViewportSize.Y / 2) - 250
	)
)
local maintab = Window:CreateTab('Main')

--[[
local VirtualInputManager = game:GetService("VirtualInputManager")

game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, nil, 0)
task.wait()
game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, false, nil, 0)
]]

local function Lives()
    if game.Players.LocalPlayer.Character then
        if game.Players.LocalPlayer.Character:FindFirstChild('HumanoidRootPart') then
            if game.Players.LocalPlayer.Character:FindFirstChild('Humanoid') then
                if game.Players.LocalPlayer.Character:FindFirstChild('Humanoid').Health >= 1 then
                    return true
                else
                    return false
                end
            else
                return false
            end
        else
            return false
        end
    else
        return false
    end
end

local function cne_Rod()
    local rodname = game:GetService("Players").LocalPlayer.inventory.rodsEquippedName.Value
    if Lives() then
        for i, tool in game.Players.LocalPlayer.Character:GetChildren() do
            if tool.ClassName =='Tool' and tool.Name ~= rodname then
                tool.Parent = game.Players.LocalPlayer.Backpack
            end
        end
        if not game.Players.LocalPlayer.Character:FindFirstChild(rodname) then
            if game.Players.LocalPlayer.Backpack:FindFirstChild(rodname) then
                game.Players.LocalPlayer.Backpack:FindFirstChild(rodname).Parent = game.Players.LocalPlayer.Character
            end
        end
    end
end

local function SellAll(v)
    local hhe = 0
    for i, u in game:GetService("Players").LocalPlayer.inventory.fishes:GetChildren() do
        hhe+=1
    end
    if hhe >= v and Lives() then
        local hut = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(815.194214, 125.560997, -250.464111, -0.847631931, 0, 0.530584812, 0, 1, 0, -0.530584812, 0, -0.847631931)
        task.wait(_G.candyhub.sellallwait)
        for i, fish in game:GetService("Players").LocalPlayer.inventory.fishes:GetChildren() do
            local args = {[1] = fish.Name,[2] = fish:GetAttribute('itemId')}
            game:GetService("ReplicatedStorage"):WaitForChild("events"):WaitForChild("fishing"):WaitForChild("itemSell"):InvokeServer(unpack(args))        
        end
        task.wait(2.2)
        game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = hut
    end
end
local farmsection = maintab:AddCategory("Auto Farm",1,1)
farmsection:AddToggle('Auto Cast',false,'',function(v)
	_G.candyhub.autocast = v
    while _G.candyhub.autocast and task.wait(1.0) do
        if _G.candyhub.castmode == 'bypass' then
            if Lives() then
                cne_Rod()
                if not game.Players.LocalPlayer.Character:FindFirstChild('HumanoidRootPart'):FindFirstChild('fishingRodPower').Enabled then
                    if not game:GetService("Players").LocalPlayer.fishing.general.activeFishing.Value then
                        if not game:GetService("Players").LocalPlayer.fishing.general.activeFighting.Value then
                            local h = game:GetService("Players").LocalPlayer.gui.autofishing.Value
                            game:GetService("Players").LocalPlayer.gui.autofishing.Value = true
                            game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, nil, 0)
                            if not ame:GetService("Players").LocalPlayer.fishing.general.activeFishing.Value and not game:GetService("Players").LocalPlayer.fishing.general.activeFighting.Value then
                                task.wait(_G.candyhub.holdtime)
                            end
                            game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, false, nil, 0)
                            game:GetService("Players").LocalPlayer.gui.autofishing.Value = h
                        end
                    end
                end
            end
        elseif _G.candyhub.castmode == 'normal' then
            if Lives() then
                cne_Rod()
                if not game.Players.LocalPlayer.Character:FindFirstChild('HumanoidRootPart'):FindFirstChild('fishingRodPower').Enabled then
                    if not game:GetService("Players").LocalPlayer.fishing.general.activeFishing.Value then
                        if not game:GetService("Players").LocalPlayer.fishing.general.activeFighting.Value then
                            game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, nil, 0)
                            task.wait(1.3) -- repeat task.wait() until game.Players.LocalPlayer.Character:FindFirstChild('HumanoidRootPart'):FindFirstChild('fishingRodPower').luckMultiplayer.Size.X.Scale >= 9.8
                            game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, false, nil, 0)
                        end
                    end
                end
            end
        end
    end
end)

farmsection:AddToggle('Auto Catch',false,'',function(v)
	_G.candyhub.autocatch = v
    while _G.candyhub.autocatch and task.wait() do
        if game:GetService("Players").LocalPlayer.fishing.general.activeFighting.Value then
            game:GetService("ReplicatedStorage"):WaitForChild("events"):WaitForChild("fishing"):WaitForChild("fightClick"):FireServer()
        end
    end
end)

farmsection:AddToggle('Auto Target', false, '', function(v)
    _G.candyhub.autotarget = v
    while _G.candyhub.autotarget and task.wait() do
        local targetFrame = game:GetService('Players').LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("fishing"):WaitForChild("targetFrame")
        AntiGamepass('make')
        for _, target in ipairs(targetFrame:GetChildren()) do
            AntiGamepass('check_true')
            if target:IsA("GuiObject") and _G.candyhub.autotarget and target.Name == 'target' and target:FindFirstChild('ImageButton') then
                game:GetService('GuiService').SelectedObject = target:FindFirstChild('ImageButton')
                task.wait()
                if game:GetService('GuiService').SelectedObject == target:FindFirstChild('ImageButton') and target.Name == 'target' then
                    game:GetService('VirtualInputManager'):SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                    task.wait()
                    game:GetService('VirtualInputManager'):SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                end
                task.wait()
            end
            task.wait(0.08)
        end
        AntiGamepass('make')
        AntiGamepass('check_false')
        game:GetService('GuiService').SelectedObject = nil
    end
end)

farmsection:AddDropdown('Cast Mode: ', {'bypass','normal'},'bypass','',function(v)
	_G.candyhub.castmode = v
end, true)

local section3 = maintab:AddCategory("Auto Stats",1,1)
section3:AddToggle('Auto Skills',false,'',function(v)
	_G.candyhub.autostat = v
    while _G.candyhub.autostat and task.wait(1) do
        if game:GetService("Players").LocalPlayer.realstats.upgradePoints.Value >=1 then
            if _G.candyhub.stats.fishingspeed then
                game:GetService("ReplicatedStorage"):WaitForChild("events"):WaitForChild("fishing"):WaitForChild("canPurchaseUpgrade"):InvokeServer("speedBoost")
            end
        end
        if game:GetService("Players").LocalPlayer.realstats.upgradePoints.Value >=1 then
            if _G.candyhub.stats.strength then
                game:GetService("ReplicatedStorage"):WaitForChild("events"):WaitForChild("fishing"):WaitForChild("canPurchaseUpgrade"):InvokeServer("powerBoost")                
            end
        end
        if game:GetService("Players").LocalPlayer.realstats.upgradePoints.Value >=1 then
            if _G.candyhub.stats.luck then
                game:GetService("ReplicatedStorage"):WaitForChild("events"):WaitForChild("fishing"):WaitForChild("canPurchaseUpgrade"):InvokeServer("luckBoost")                
            end
        end
    end
end)
section3:AddToggle('+ Fishing Speed',false,'',function(v)
	_G.candyhub.stats.fishingspeed = v
end)
section3:AddToggle('+ Strength',false,'',function(v)
	_G.candyhub.stats.strength = v
end)
section3:AddToggle('+ Luck',false,'',function(v)
	_G.candyhub.stats.luck = v
end)



local section2 = maintab:AddCategory("Auto Sell",2,1)

section2:AddSlider('Sell When Have Fish', {1, 350, 50, 1, ""}, '', function(v)
    _G.candyhub.sellamount = v
end, false)

section2:AddToggle('Auto Sell Fish',false,'',function(v)
	_G.candyhub.autosell = v
    while _G.candyhub.autosell and task.wait(3) do
        SellAll(_G.candyhub.sellamount)
    end
end)

section2:AddToggle('Auto Upgrade Fish',false,'',function(v)
	_G.candyhub.autoupgrade_fish = v
    while _G.candyhub.autoupgrade_fish and task.wait(1) do
        for i, fish in game:GetService("Players").LocalPlayer.inventory.fishes:GetChildren() do
            local args = {
                [1] = fish.Name,
                [2] = "fishes",
                [3] = fish:GetAttribute('itemId')
            }
            game:GetService("ReplicatedStorage"):WaitForChild("events"):WaitForChild("gui"):WaitForChild("canUpgradeTier"):InvokeServer(unpack(args))            
        end
    end
end)

section2:AddToggle('Auto Upgrade Gift',false,'',function(v)
	_G.candyhub.autoupgrade_present = v
    while _G.candyhub.autoupgrade_present and task.wait(1) do
        for i, present in game:GetService("Players").LocalPlayer.inventory.chests:GetChildren() do
            local args = {
                [1] = present.Name,
                [2] = "chests",
                [3] = present:GetAttribute('itemId')
            }
            game:GetService("ReplicatedStorage"):WaitForChild("events"):WaitForChild("gui"):WaitForChild("canUpgradeTier"):InvokeServer(unpack(args))   
        end
    end
end)

--[[ -- patched
section2:AddToggle('No Bait Losing', false, '', function(v)
    _G.candyhub.infbait = v
    while _G.candyhub.infbait and task.wait(.5) do
        local bait = game:GetService("Players").LocalPlayer.inventory.baits:FindFirstChild(game:GetService("Players").LocalPlayer.inventory.baitsEquippedName.Value)
        if not game:GetService("Players").LocalPlayer.fishing.general.activeFishing.Value then
            local args = {[1] = "baits", [2]=bait}
            game:GetService("ReplicatedStorage"):WaitForChild("events"):WaitForChild("fishing"):WaitForChild("canEquipItem"):InvokeServer(unpack(args))
        else
            game:GetService("Players").LocalPlayer.inventory.baitsEquippedName.Value='Hook'
            repeat task.wait(.5) until not game:GetService("Players").LocalPlayer.fishing.general.activeFishing.Value do
                task.wait(1)
                game:GetService("Players").LocalPlayer.inventory.baitsEquippedName.Value = bait
            end
        end
    end
end)
]]

local section_cz = maintab:AddCategory("Cast Zone",2,1)
section_cz:AddDropdown('Teleport To Cast-Zone', {'Default Isle','Vulcano Isle','Snowy Biome','Deep Waters','Ancient Ocean','High Field', 'Toxic Zone','Mansion Island','Christmas Village'},'','',function(v)
	if Lives() then
        if v == 'Default Isle' then
            _G.candyhub.zone = zones.defaultisle
        elseif v == 'Vulcano Isle' then
            _G.candyhub.zone = zones.vulcanoisle
        elseif v == 'Snowy Biome' then
            _G.candyhub.zone = zones.snowybiome
        elseif v == 'Deep Waters' then
            _G.candyhub.zone = zones.deepwaters
        elseif v == 'Ancient Ocean' then
            _G.candyhub.zone = zones.ancientocean
        elseif v == 'High Field' then
            _G.candyhub.zone = zones.highfield
        elseif v == 'Toxic Zone' then
            _G.candyhub.zone = zones.toxiczone
        elseif v == 'Mansion Island' then
            _G.candyhub.zone = zones.mansionisland
        elseif v == 'Christmas Village' then
            _G.candyhub.zone = zones.christmasvilage
        end
    end
end, true)
section_cz:AddToggle('Auto Cast Zone',false,'',function(v)
	_G.candyhub.autozone = v
    while _G.candyhub.autozone and task.wait(1.5) do
        local hhe = 0
        for i, u in game:GetService("Players").LocalPlayer.inventory.fishes:GetChildren() do
            hhe+=1
        end
        if Lives() and _G.candyhub.sellamount > hhe then
            game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
            SafeZone(_G.candyhub.zone)
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = _G.candyhub.zone + Vector3.new(0,3,0)
            if _G.candyhub.freezechar then
                game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = true
            end
        end
    end
end)
section_cz:AddToggle('Freeze Character',false,'',function(v)
    _G.candyhub.freezechar = v
    while _G.candyhub.freezechar and task.wait(.05) do
        if Lives() then
            game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = _G.candyhub.freezechar
        end
    end
    if _G.candyhub.freezechar == false then
        game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
    end
end)

local tab2 = Window:CreateTab('Shop')
local section3 = tab2:AddCategory("Buy",1,1)

local rods = {'Steel Rod','Gold Rod','Diamond Rod','Amethyst Rod','Angel Rod','Shark Rod',
'Rainbow Rod','Devil Rod','Bone Rod','Dead Rod','Trident Rod','Medusa Rod','Hammer Rod','Spider Rod',
'Thunder Rod','Toxic Rod','Nuke Rod','Light Saber Rod'}

local baits = {'Apple','Carrot','Grapes','Worm','Gummy','Fish Bait','Star','Gold','Magma','Diamond','Rainbow','Galaxy','Hairy','Rocket','Nuke','Blackhole'}

local potions = {
'Luck Potion I','Luck Potion II','Luck Potion III',
'Strength Potion I','Strength Potion II','Strength Potion III',
'Speed Potion I','Speed Potion II','Speed Potion III'
}

section3:AddDropdown('Rod: ', rods,'Steel Rod','',function(v)
	_G.candyhub.rod = v
end, true)

section3:AddButton('Buy Rod', function()
    for i=1,_G.candyhub.buyamount do
    if not game:GetService("Players").LocalPlayer.inventory.rods:FindFirstChild(_G.candyhub.rod) then
        local args = {[1] = _G.candyhub.rod,[2] = "rods",[3] = "fishingSettings",[4] = "oneTime"}
        game:GetService("ReplicatedStorage"):WaitForChild("events"):WaitForChild("fishing"):WaitForChild("canShopPurchase"):InvokeServer(unpack(args))
    end
end
end)

section3:AddDropdown('Bait: ', baits,'Apple','',function(v)
	_G.candyhub.bait = v
end, true)

section3:AddButton('Buy Bait', function()
    for i=1,_G.candyhub.buyamount do
    local args = {[1] = _G.candyhub.bait,[2] = "baits",[3] = "fishingSettings",[4] = "manyTime"}
    game:GetService("ReplicatedStorage"):WaitForChild("events"):WaitForChild("fishing"):WaitForChild("canShopPurchase"):InvokeServer(unpack(args))    
    end
end)

section3:AddDropdown('Potion: ', potions,'Luck Potion I','',function(v)
	_G.candyhub.potion = v
end, true)

section3:AddButton('Buy Potion', function()
    for i=1,_G.candyhub.buyamount do
    local args = {[1] = _G.candyhub.potion,[2] = "potions",[3] = "fishingSettings",[4] = "manyTime"}
    game:GetService("ReplicatedStorage"):WaitForChild("events"):WaitForChild("fishing"):WaitForChild("canShopPurchase"):InvokeServer(unpack(args))  
    end  
end)

section3:AddSlider('Buy Amount', {1, 50, 1, 1, ""}, '', function(v)
    _G.candyhub.buyamount = v
end, false)

local section222 = tab2:AddCategory("Auto Bait",2,1)
section222:AddDropdown('Bait: ', baits,'Apple','',function(v)
	_G.candyhub.abait = v or 'Apple'
end, true)
section222:AddToggle('Auto Buy Bait on use',false,'',function(v)
	_G.candyhub.autobait = v
    while _G.candyhub.autobait and task.wait() do
        local h = game:GetService("Players").LocalPlayer.inventory.baits:FindFirstChild(_G.candyhub.abait).Value
        repeat task.wait() until game:GetService("Players").LocalPlayer.inventory.baits:FindFirstChild(_G.candyhub.abait).Value < h or not _G.candyhub.autobait
        if _G.candyhub.autobait then
            local args = {[1] = _G.candyhub.abait,[2] = "baits",[3] = "fishingSettings",[4] = "manyTime"}
            game:GetService("ReplicatedStorage"):WaitForChild("events"):WaitForChild("fishing"):WaitForChild("canShopPurchase"):InvokeServer(unpack(args))    
        end
    end
end)
--[[
section222:AddToggle('Inf Bait (patched)', false, '', function(v)
    _G.candyhub.infbait = v
    while _G.candyhub.infbait and task.wait() do
        local bait = game:GetService("Players").LocalPlayer.inventory.baitsEquippedName.Value
        if not game:GetService("Players").LocalPlayer.fishing.general.activeFishing.Value and not game:GetService("Players").LocalPlayer.fishing.general.activeFighting.Value then
            game:GetService("Players").LocalPlayer.inventory.baitsEquippedName.Value = bait
        else
            game:GetService("Players").LocalPlayer.inventory.baitsEquippedName.Value='Hook'
            repeat task.wait(.3) until not game:GetService("Players").LocalPlayer.fishing.general.activeFishing.Value do
                task.wait(1)
                game:GetService("Players").LocalPlayer.inventory.baitsEquippedName.Value = bait
            end
        end
    end
end)
]]

local tab3 = Window:CreateTab('Area')
local section4 = tab3:AddCategory("Teleport",1,1)

section4:AddDropdown('Teleport To Island', {'Default Isle','Vulcano Isle','Snowy Biome','Deep Waters','Ancient Ocean','High Field', 'Toxic Zone','Mansion Island','Christmas Village'},'','',function(v)
	if Lives() then
        if v == 'Default Isle' then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = spawns.defaultisle + Vector3.new(0,3,0)
        elseif v == 'Vulcano Isle' then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = spawns.vulcanoisle + Vector3.new(0,3,0)
        elseif v == 'Snowy Biome' then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = spawns.snowybiome + Vector3.new(0,3,0)
        elseif v == 'Deep Waters' then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = spawns.deepwaters + Vector3.new(0,3,0)
        elseif v == 'Ancient Ocean' then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = spawns.ancientocean + Vector3.new(0,3,0)
        elseif v == 'High Field' then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = spawns.highfield + Vector3.new(0,3,0)
        elseif v == 'Toxic Zone' then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = spawns.toxiczone + Vector3.new(0,3,0)
        elseif v == 'Mansion Island' then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = spawns.mansionisland + Vector3.new(0,6,0)
        elseif v == 'Christmas Village' then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = spawns.christmasvilage + Vector3.new(0,3,0)
        end
    end
end, true)

local section5 = tab3:AddCategory("Settings/Zone",2,1)

section5:AddDropdown('Teleport To Cast-Zone', {'Default Isle','Vulcano Isle','Snowy Biome','Deep Waters','Ancient Ocean','High Field', 'Toxic Zone','Mansion Island','Christmas Village'},'','',function(v)
	if Lives() then
        if v == 'Default Isle' then
            SafeZone(zones.defaultisle)
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = zones.defaultisle + Vector3.new(0,3,0)
        elseif v == 'Vulcano Isle' then
            SafeZone(zones.vulcanoisle)
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = zones.vulcanoisle + Vector3.new(0,3,0)
        elseif v == 'Snowy Biome' then
            SafeZone(zones.snowybiome)
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = zones.snowybiome + Vector3.new(0,3,0)
        elseif v == 'Deep Waters' then
            SafeZone(zones.deepwaters)
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = zones.deepwaters + Vector3.new(0,3,0)
        elseif v == 'Ancient Ocean' then
            SafeZone(zones.ancientocean)
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = zones.ancientocean + Vector3.new(0,3,0)
        elseif v == 'High Field' then
            SafeZone(zones.highfield)
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = zones.highfield + Vector3.new(0,3,0)
        elseif v == 'Toxic Zone' then
            SafeZone(zones.toxiczone)
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = zones.toxiczone + Vector3.new(0,3,0)
        elseif v == 'Mansion Island' then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = zones.mansionisland + Vector3.new(0,6,0)
        elseif v == 'Christmas Village' then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = zones.christmasvilage + Vector3.new(0,3,0)
        end
    end
end, true)
