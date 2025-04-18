if game.CoreGui:FindFirstChild('hexagon-docs') then
	game.CoreGui:FindFirstChild('hexagon-docs'):Destroy()
end
local library = loadstring(game:HttpGet('https://raw.githubusercontent.com/vateq/UILIBrewrites/refs/heads/main/hexagonuilib'))()
library.settings = {
	guiname = "hexagon-docs",
	title = 'CandyHub - Grow a Garden',
	modal = true,
	font = Enum.Font.SourceSans,
	textsize = 16,
	logo = "rbxassetid://4350178803",
	footer = ' - ',
	textstroke = true,
}

local Window = library:CreateWindow(
	Vector2.new(400, 500),
	Vector2.new((workspace.CurrentCamera.ViewportSize.X / 2) - 250, (workspace.CurrentCamera.ViewportSize.Y / 2) - 250) -- ui pointing (id what i just called it lol) just dont change it.
)

local sellcords = CFrame.new(52.4025459, 2.99999976, -0.0815055743, 0.0126645789, -2.00841122e-08, -0.999919772, -3.24118599e-09, 1, -2.01267749e-08, 0.999919772, 3.49582319e-09, 0.0126645789)
local getinv = function()
    return game.Players.LocalPlayer.Backpack:GetChildren() 
end

local getsellables = function()
    local sellables = {}
    local currentitem = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
    for i, item in game.Players.LocalPlayer.Backpack:GetChildren() do
        if string.find(item.Name, "kg") then
            if not item:GetAttribute("Favorite") then
                table.insert(sellables,item.Name)
            end
        end
    end
    if currentitem then
        if string.find(currentitem.Name, "kg") then
            if not currentitem:GetAttribute("Favorite") then
                table.insert(sellables,currentitem.Name)
            end
        end
    end
    return sellables
end

local getseeds = function()
    local seeds = {}
    for i, item in game:GetService("Players").LocalPlayer.PlayerGui.Seed_Shop.Frame.ScrollingFrame:GetChildren() do
        if item:FindFirstChildOfClass("Frame") then
            table.insert(seeds,item.Name)
        end
    end
    return seeds
end

local getgears = function()
    local gears = {}
    for i, item in game:GetService("Players").LocalPlayer.PlayerGui.Gear_Shop.Frame.ScrollingFrame:GetChildren() do
        if item:FindFirstChildOfClass("Frame") then
            table.insert(gears,item.Name)
        end
    end
    return gears
end

local getgarden = function()
    local gardenx = nil
    for i, garden in workspace.Farm:GetChildren() do
        if garden:FindFirstChild("Important") then
            if garden:FindFirstChild("Important"):FindFirstChild("Data") then
                if garden:FindFirstChild("Important"):FindFirstChild("Data"):FindFirstChild("Owner") then
                    if garden:FindFirstChild("Important"):FindFirstChild("Data"):FindFirstChild("Owner").Value == game.Players.LocalPlayer.Name then
                        gardenx = garden
                    end
                end
            end 
        end
    end
    return gardenx
end

local collect = function(proximity,range)
    local part = proximity.Parent
    local root = game.Players.LocalPlayer.Character.HumanoidRootPart
    local magnitude = (part.Position - root.Position).Magnitude

    if magnitude < range then
        fireproximityprompt(proximity)
    end
end

local collectall = function(range)
    local farm = getgarden()
    local plants = farm.Important.Plants_Physical
    local oldc = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame   

    for _, plant in ipairs(plants:GetDescendants()) do
        if plant.ClassName == "ProximityPrompt" then
            collect(plant,range or 17)
        end
    end
end

local sellinv = function(atp)
    local oldcords = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
    if #getsellables() >= 1 then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = sellcords
        repeat
            task.wait()
            if atp then game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = sellcords end 
            game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("Sell_Inventory"):FireServer() 
        until #getsellables() == 0
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = oldcords
    end
end

--if not _G.candyhub then
_G.candyhub = {

    autoplant = false,

    autocollect = false,
    collectrate = 500,
    tpcollect = false,
    tprate = 10,

    autobuy = false,
    selectedseeds = {"Carrot"},

    autosell = false,
    sellonfruits = 50,
    salefocus = false,

    dupeamount = 100,
}
--end

local maintab = Window:CreateTab('Main')
local category5525 = maintab:AddCategory("Auto Farm",1,1)
category5525:AddToggle('Auto Plant',_G.candyhub.autoplant,'',function(v)
    task.spawn(function()
        
        _G.candyhub.autoplant = v

    end)
end)

local category = maintab:AddCategory("Collector",1,1)
category:AddToggle('Auto Collect',_G.candyhub.autocollect,'',function(v)
    task.spawn(function()
        
        _G.candyhub.autocollect = v

        while _G.candyhub.autocollect and task.wait(_G.candyhub.collectrate/1000) do

            local farm = getgarden()
            local plants = farm.Important.Plants_Physical
            local oldc = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame   

            if _G.candyhub.tpcollect then
                for _, plant in ipairs(plants:GetDescendants()) do
                    if plant.ClassName == "ProximityPrompt" then
                        if plant.Parent and plant then
                            if plant.Parent.Parent:FindFirstChild(plant.Parent.Name) then
                                oldc = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = plant.Parent.CFrame
                                task.wait(_G.candyhub.tprate/1000)
                                collectall(17)
                                task.wait(_G.candyhub.tprate/1000)
                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = oldc
                            end
                        end
                    end
                end
            else
                collectall(17)
            end

        end

    end)
end)

category:AddSlider('Collect Rate', {100, 3000, _G.candyhub.collectrate, 1, ""}, '', function(v)
    task.spawn(function()
        _G.candyhub.collectrate = v
    end)
end, false)


category:AddToggle('Transport Collect',_G.candyhub.tpcollect,'',function(v)
    task.spawn(function()
        _G.candyhub.tpcollect = v
    end)
end)

category:AddSlider('Transport Rate', {1, 1000, _G.candyhub.tprate, 1, ""}, '', function(v)
    task.spawn(function()
        _G.candyhub.tprate = v
    end)
end, false)

local category3 = maintab:AddCategory("Seed Sniper",1,1)

category3:AddMultiDropdown('Seeds: ', getseeds(), {'Carrot'}, '', function(v)
    _G.candyhub.selectedseeds = v
end, true)

category3:AddToggle('Auto Buy Selected',_G.candyhub.autobuy,'',function(v)
    task.spawn(function()
        _G.candyhub.autobuy = v
        while _G.candyhub.autobuy and task.wait(1) do
            for _, fruit in _G.candyhub.selectedseeds do
                local args = {[1] = fruit}
                game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("BuySeedStock"):FireServer(unpack(args))                
            end
        end
    end)
end)

local category623 = maintab:AddCategory("Gear Sniper",1,1)

category623:AddMultiDropdown('Gears: ', getgears(), {'BasicSprinkler'}, '', function(v)
    _G.candyhub.selectedgears = v
end, true)

category623:AddToggle('Auto Buy Selected',_G.candyhub.autobuygear,'',function(v)
    task.spawn(function()
        _G.candyhub.autobuygear = v
        while _G.candyhub.autobuygear and task.wait(1) do
            for _, gear in _G.candyhub.selectedgears do
                if gear == "WateringCan" then
                    local args = {[1] = gear, [2] = 10}
                    game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("BuySeedStock"):FireServer(unpack(args))
                else
                    local args = {[1] = gear, [2] = 0}
                    game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("BuySeedStock"):FireServer(unpack(args))
                end
            end
        end
    end)
end)

local category2 = maintab:AddCategory("Auto Sell",2,1)
category2:AddToggle('Auto Sell',_G.candyhub.autosell,'',function(v)
    task.spawn(function()
        _G.candyhub.autosell = v
        while _G.candyhub.autosell and task.wait(1) do
            if _G.candyhub.sellonfruits ~= 0 then
                if #getinv() >= _G.candyhub.sellonfruits then
                    sellinv(_G.candyhub.salefocus)
                end
            end
        end
    end)
end)
category2:AddToggle('SaleFocus (afk farming)',_G.candyhub.salefocus,'',function(v)
    task.spawn(function()
        _G.candyhub.salefocus = v
    end)
end)
category2:AddSlider('Sell All On Fruits: ', {0, 200, _G.candyhub.sellonfruits, 1, ""}, '', function(v)
    task.spawn(function()
        _G.candyhub.sellonfruits = v
    end)
end, false)

category2:AddButton('Sell All Once', function()
    sellinv()
end)

local misctab = Window:CreateTab('Misc')
local category3525 = eventtab:AddCategory("Event",1,1)
category3525:AddToggle('Auto Collect Eggs (WIP)',false,'',function(v)
    task.spawn(function()
    end)
end)

local category5 = maintab:AddCategory("IngameStuff",2,1)
category5:AddButton('Enable Game Fly (F) (WIP)', function()
    local env = getsenv(game:GetService("Players").LocalPlayer.PlayerScripts.FlyScript)
    env.v_u_19[Enum.KeyCode.F]["TOGGLE"]()
end)

local category325 = misctab:AddCategory("WateringCan-Dupe",2,1)

category325:AddButton('Buy (50K$)', function()
    local args = {
        [1] = "WateringCan",
        [2] = _G.candyhub.dupeamount
    }
    
    game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("BuyGearStock"):FireServer(unpack(args))    
end)

category325:AddSlider('Uses: ', {10, 100, _G.candyhub.dupeamount, 1, ""}, '', function(v)
    task.spawn(function()
        _G.candyhub.dupeamount = v
    end)
end, false)

category325:AddLabel('how to use:', '')
category325:AddLabel('u need 10 watering can first', '')
category325:AddLabel('then you buy x100', '')
category325:AddLabel('then u rejoin', '')
category325:AddLabel('and buy 10 watering can again', '')
category325:AddLabel('then x100 again', '')
